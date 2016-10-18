class CollectionExtensions {

	func toUInt32Array(collection: ArraySlice<UInt8>) -> Array<UInt32> {
        var result = Array<UInt32>()
        result.reserveCapacity(16)
        for idx in stride(from: collection.startIndex, to: collection.endIndex, by: MemoryLayout<UInt32>.size) {
            var val: UInt32 = 0
            val |= collection.count > 3 ? UInt32(collection[idx.advanced(by: 3)]) << 24 : 0
            val |= collection.count > 2 ? UInt32(collection[idx.advanced(by: 2)]) << 16 : 0
            val |= collection.count > 1 ? UInt32(collection[idx.advanced(by: 1)]) << 8  : 0
            val |= collection.count > 0 ? UInt32(collection[idx]) : 0
            result.append(val)
        }

        return result
    }

	func toUInt64Array(collection: ArraySlice<UInt8>) -> Array<UInt64> {
        var result = Array<UInt64>()
        result.reserveCapacity(32)
        for idx in stride(from: collection.startIndex, to: collection.endIndex, by: MemoryLayout<UInt64>.size) {
            var val:UInt64 = 0
            val |= collection.count > 7 ? UInt64(collection[idx.advanced(by: 7)]) << 56 : 0
            val |= collection.count > 6 ? UInt64(collection[idx.advanced(by: 6)]) << 48 : 0	
            val |= collection.count > 5 ? UInt64(collection[idx.advanced(by: 5)]) << 40 : 0
            val |= collection.count > 4 ? UInt64(collection[idx.advanced(by: 4)]) << 32 : 0
            val |= collection.count > 3 ? UInt64(collection[idx.advanced(by: 3)]) << 24 : 0
            val |= collection.count > 2 ? UInt64(collection[idx.advanced(by: 2)]) << 16 : 0
            val |= collection.count > 1 ? UInt64(collection[idx.advanced(by: 1)]) << 8 : 0
            val |= collection.count > 0 ? UInt64(collection[idx.advanced(by: 0)]) << 0 : 0
            result.append(val)
        }

        return result
    }

}