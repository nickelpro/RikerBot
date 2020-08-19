#include "smpmap.hpp"
#include "datautils.hpp"

namespace rkr {

ChunkSection::ChunkSection(std::istream& data) {
  update(data);
}

void ChunkSection::update(std::istream& data) {
  block_count = mcd::dec_be16(data);
  std::uint8_t bits_per_block = mcd::dec_byte(data);
  if(bits_per_block < 8) {
    if(bits_per_block < 4)
      bits_per_block = 4;
    update_palette(data, bits_per_block);
  } else {
    update_direct(data, bits_per_block);
  }
}

void ChunkSection::update_direct(std::istream& data,
    std::uint8_t bits_per_block) {
  std::int32_t len = mcd::dec_varint(data);
  int bits_remaining = 0;
  std::uint64_t cur_long;
  std::uint64_t mask = (1UL << bits_per_block) - 1;
  for(auto& el : blocks) {
    if(bits_remaining < bits_per_block) {
      cur_long = mcd::dec_be64(data);
      bits_remaining = 64;
      len--;
    }
    el = static_cast<block_id>(cur_long&mask);
    cur_long >>= bits_per_block;
    bits_remaining -= bits_per_block;
  }
  // There's some situations where there's rando garbage at the end of the
  // array
  if(len)
    data.ignore(len * sizeof(cur_long));
}

void ChunkSection::update_palette(std::istream& data,
    std::uint8_t bits_per_block) {
  std::vector<block_id> palette(mcd::dec_varint(data));
  for(auto& el : palette)
    el = static_cast<block_id>(mcd::dec_varint(data));
  std::int32_t len = mcd::dec_varint(data);
  int bits_remaining = 0;
  std::uint64_t cur_long;
  std::uint64_t mask = (1UL << bits_per_block) - 1;
  for(auto& el : blocks) {
    if(bits_remaining < bits_per_block) {
      cur_long = mcd::dec_be64(data);
      bits_remaining = 64;
      len--;
    }
    el = palette[cur_long&mask];
    cur_long >>= bits_per_block;
    bits_remaining -= bits_per_block;
  }
  if(len)
    data.ignore(len * sizeof(cur_long));
}

void ChunkSection::update(std::uint8_t x, std::uint8_t y, std::uint8_t z,
    block_id block) {
  blocks[x + (z + y*16)*16] = block;
}

block_id ChunkSection::get(std::uint8_t x, std::uint8_t y, std::uint8_t z) {
  return blocks[x + (z + y*16)*16];
}

void ChunkColumn::update(std::uint16_t bitmask, std::istream& data) {
  for(unsigned int i = 0; i < std::size(sections); i++)
    if(bitmask & (1<<i)) {
      if(sections[i])
        sections[i].value().update(data);
      else
        sections[i].emplace(data);
    }
}

void ChunkColumn::update(std::uint8_t sec_coord,
    const std::vector<std::int64_t>& records) {
  auto& section = sections[sec_coord];
  for(auto el : records) {
    std::uint8_t y = el&0xF;
    std::uint8_t z = (el>>=4)&0xF;
    std::uint8_t x = (el>>=4)&0xF;
    block_id block = el>>4;
    section.value().update(x, y, z, block);
  }
}

std::vector<std::pair<block_id, std::int32_t>> ChunkColumn::get(
    std::vector<std::array<std::int32_t, 4>>& positions) {
  std::vector<std::pair<block_id, std::int32_t>> ret(positions.size());
  for(int i = 0, end = positions.size(); i < end; i++) {
    auto pos = positions[i];
    auto section = sections[pos[1] / 16];
    if(section)
      ret[i] = {section.value().get(pos[0], pos[1] % 16, pos[2]), pos[3]};
    else
      ret[i] = {0, pos[3]};
  }
  return ret;
}


void SMPMap::update(const mcd::ClientboundMapChunk& packet) {
  boost::interprocess::ibufferstream ibuf(packet.chunkData.data(),
      packet.chunkData.size());
  chunks[{packet.x, packet.z}].update(packet.bitMap, ibuf);
}

void SMPMap::update(const mcd::ClientboundMultiBlockChange& packet) {
  chunks[{packet.chunkCoordinates.x, packet.chunkCoordinates.z}].update(
      packet.chunkCoordinates.y, packet.records);
}

void SMPMap::unload(const mcd::ClientboundUnloadChunk& packet) {
  chunks.erase({packet.chunkX, packet.chunkZ});
}

std::vector<block_id> SMPMap::get(const std::vector<mcd::mc_position>&
    positions) {
  std::vector<block_id> ret(positions.size());
  std::unordered_map<chunk_coord, std::vector<std::array<std::int32_t, 4>>,
      boost::hash<chunk_coord>> map;
  for(int32_t i = 0, end = positions.size(); i < end; i++) {
    auto& pos = positions[i];
    std::int32_t chunk_x = pos.x / 16;
    std::int32_t x = pos.x % 16;
    std::int32_t chunk_z = pos.z / 16;
    std::int32_t z = pos.z % 16;
    map[{chunk_x, chunk_z}].push_back({x, pos.y, z, i});
  }
  for(auto& el : map) {
    if(chunks.contains(el.first)) {
      for(auto& coord : chunks[el.first].get(el.second))
        ret[coord.second] = coord.first;
    } else {
      for(auto& coord : el.second)
        ret[coord[3]] = 0;
    }
  }
  return ret;
}

std::vector<block_id> SMPMap::get(const std::vector<std::array<
    std::int32_t, 3>>& positions) {
  std::vector<block_id> ret(positions.size());
  std::unordered_map<chunk_coord, std::vector<std::array<std::int32_t, 4>>,
      boost::hash<chunk_coord>> map;
  for(int32_t i = 0, end = positions.size(); i < end; i++) {
    auto& pos = positions[i];
    std::int32_t chunk_x = pos[0] / 16;
    std::int32_t x = pos[0] % 16;
    std::int32_t chunk_z = pos[2] / 16;
    std::int32_t z = pos[2] % 16;
    map[{chunk_x, chunk_z}].push_back({x, pos[1], z, i});
  }
  for(auto& el : map) {
    if(chunks.contains(el.first)) {
      for(auto& coord : chunks[el.first].get(el.second))
        ret[coord.second] = coord.first;
    } else {
      for(auto& coord : el.second)
        ret[coord[3]] = 0;
    }
  }
  return ret;
}

} // namespace rkr