import system
import nimSHA2
import streams
import os


# doAssert strm.readData(addr(buffer), 1024) == 5
# doAssert buffer == ['a', 'b', 'c', 'd', 'e', '\x00']
# doAssert strm.atEnd() == true
# strm.close()

proc hash_path(path: string) =
    if unlikely(not fileExists(path)):
        raise newException(IOError, "path not found")
    let stream = newFileStream(path, mode=fmRead)
    defer: stream.close()

    var buf: array[8096, char]
    var numRead: int = 0

    var sha: SHA256
    sha.initSHA()

    while true:
        numRead = stream.readData(buf.addr, 8096)
        echo numRead
        echo buf[0..numRead]
        # sha.update(toString(buf[0..numRead]))
        if numRead <= 0:
            break

                # Check magic string
                #   var magic_string: array[6, char]
                #     discard stream.readData(magic_string.addr, 6)

# proc hash_path(): string =
#   var strm = newFileStream("file.bin", fmRead)
#   if not isNil(strm):
#     var buffer: array[8096, char]
#     var bytesRead: int = 0
#     while true:
#       bytesRead = strm.readData(addr(buffer), 8096)
#       if bytesRead <= 0:
#         break
#       echo buffer[:bytesRead]
#     strm.close()

#    const blockSize = 8192
#    var bytesRead: int = 0
#    var buffer: string

#    var f: File = open("./file.bin")

#    buffer = newString(blockSize)
#    bytesRead = f.readBuffer(buffer[0].addr, blockSize)
#    setLen(buffer,bytesRead)
#    while bytesRead > 0:
#        echo bytesRead
#        sha.update(buffer)
#
#    setLen(buffer,blockSize)
#    bytesRead = f.readBuffer(buffer[0].addr, blockSize)
#    setLen(buffer,bytesRead)
#
#    let digest = sha.final()
#    result = digest.hex()


when isMainModule:
    hash_path("file.bin")
