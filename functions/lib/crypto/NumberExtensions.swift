class NumberExtensions {

	func arrayOfBytes<T>(value:T, length:Int? = nil) -> Array<UInt8> {
		let totalBytes = length ?? MemoryLayout<T>.size

		let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
		valuePointer.pointee = value

		let bytesPointer = UnsafeMutablePointer<UInt8>(OpaquePointer(valuePointer))
		var bytes = Array<UInt8>(repeating: 0, count: totalBytes)
		for j in 0..<min(MemoryLayout<T>.size,totalBytes) {
			bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
		}
		
		valuePointer.deinitialize()
		valuePointer.deallocate(capacity: 1)
		
		return bytes
	}

    /** Array of bytes with optional padding (little-endian) */
    func bytesFromInt(i: Int, totalBytes: Int = MemoryLayout<Int>.size) -> Array<UInt8> {
        return arrayOfBytes(value: i, length: totalBytes)
    }

}