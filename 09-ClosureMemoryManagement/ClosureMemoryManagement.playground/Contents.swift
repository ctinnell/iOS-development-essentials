//
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
        }
        videoDownloader.download()
    }
    
    deinit {
        print(__FUNCTION__, " deinit")
    }
}

var video2: Video? = Video(id: 1234, name: "Video 1234", captureType: .none)
video2 = nil
print("Notice that deinit was called here because no reference to self was captured. \n")

var video: Video? = Video(id: 1234, name: "Video 1234", captureType: .strong)
video = nil
print("Notice that deinit wasn't called on either class. \n")

var video3: Video? = Video(id: 1234, name: "Video 1234", captureType: .weak)
video3 = nil
print("Notice that deinit was called here because we captured a weak reference to self here. \n")

var video4: Video? = Video(id: 1234, name: "Video 1234", captureType: .unowned)
video4 = nil
print("Notice that deinit was called here because we captured a weak reference to self here. \n")













