//: __ARC (Automatic Reference Counting)__ manages memory at compile time, and only frees up object memory when there 
//: are zero remaining strong references.
//:
//: __Strong Reference__: A normal reference that protects the referenced object from being deallocated.
//:
//: __Weak Reference__: A reference that doesn't protect the referenced object from being deallocated. In Swift, weak references are Optionals.
//:
//: __Unowned Reference__: Similar to weak references, however the references is not optional and guaranteed to not be nil.

class VideoDownloader {

    deinit {
        print(__FUNCTION__, " deinit")
    }

    var downloadComplete: (()->())?
    
    func download() {
        if let downloadComplete = downloadComplete {
            downloadComplete()
        }
    }
    
    func downloadWithMessage(completion: ()->()) {
        completion()
    }
}

class Video {
    var id: Int
    var name: String
    var videoDownloader: VideoDownloader
    enum CaptureType {
        case strong
        case weak
        case unowned
        case none
        case asFunction
    }
    
    init(id: Int, name: String,captureType: CaptureType) {
        self.id = id
        self.name = name
        self.videoDownloader = VideoDownloader()
        
        switch captureType {
        case .none:
             videoDownloader.downloadWithMessage({
                print("This block is not captured by the Video Downloader class")
                print("Video Downloaded: ", self.name)
            })
            return
        case .strong:
            videoDownloader.downloadComplete = {
                print("Strong Self - Dragons Be Here")
                print("Video Downloaded: ", self.name)
            }
        case .weak:
            videoDownloader.downloadComplete = { [weak self] in
                print("Weak Self")
                print("Video Downloaded: ", self?.name)
                print("Notice that self is optional with the weak reference.")
            }
        case .unowned:
            videoDownloader.downloadComplete = { [unowned self] in
                print("Unowned Self - The Best Option Here")
                print("Video Downloaded: ", self.name)
            }
        case .asFunction:
            videoDownloader.downloadComplete = downloadCompletion

        }

        videoDownloader.download()
    }
    
    deinit {
        print(__FUNCTION__, " deinit")
    }
    
    func downloadCompletion() {
        print("Passed as function:")
        print("Video Downloaded: ", self.name)
    }
}

var video1: Video? = Video(id: 1234, name: "Video 1234", captureType: .none)
video1 = nil
print("Notice that deinit was called here because no reference to self was captured. \n")

var video2: Video? = Video(id: 1234, name: "Video 1234", captureType: .strong)
video2 = nil
print("Notice that deinit wasn't called on either class. \n")

var video3: Video? = Video(id: 1234, name: "Video 1234", captureType: .asFunction)
video3 = nil
print("Notice that deinit was not called here because a function is just a closure, and we passed a strong reference to self. \n")

var video4: Video? = Video(id: 1234, name: "Video 1234", captureType: .weak)
video4 = nil
print("Notice that deinit was called here because we captured a weak reference to self here. \n")

var video5: Video? = Video(id: 1234, name: "Video 1234", captureType: .unowned)
video5 = nil
print("Notice that deinit was called here because we captured an unowned reference to self here. \n")















