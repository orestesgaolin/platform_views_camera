/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import AVFoundation

@available(iOS 14.0, *)
class CameraManager: ObservableObject {
  enum Status {
    case unconfigured
    case configured
    case unauthorized
    case failed
  }

  static let shared = CameraManager()

  @Published var error: CameraError?

  let session = AVCaptureSession()

  private let sessionQueue = DispatchQueue(label: "com.raywenderlich.SessionQ")
  private let videoOutput = AVCaptureVideoDataOutput()
  private var status = Status.unconfigured

  private init() {
    configure()
  }

  private func set(error: CameraError?) {
    DispatchQueue.main.async {
      self.error = error
    }
  }

  private func checkPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video) { authorized in
        if !authorized {
          self.status = .unauthorized
          self.set(error: .deniedAuthorization)
        }
        self.sessionQueue.resume()
      }
    case .restricted:
      status = .unauthorized
      set(error: .restrictedAuthorization)
    case .denied:
      status = .unauthorized
      set(error: .deniedAuthorization)
    case .authorized:
      break
    @unknown default:
      status = .unauthorized
      set(error: .unknownAuthorization)
    }
  }

  private func configureCaptureSession() {
    guard status == .unconfigured else {
      return
    }

    session.beginConfiguration()

    defer {
      session.commitConfiguration()
    }

    let device = AVCaptureDevice.default(
      .builtInWideAngleCamera,
      for: .video,
      position: .front)
    guard let camera = device else {
      set(error: .cameraUnavailable)
      status = .failed
      return
    }

    do {
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      if session.canAddInput(cameraInput) {
        session.addInput(cameraInput)
      } else {
        set(error: .cannotAddInput)
        status = .failed
        return
      }
    } catch {
      set(error: .createCaptureInput(error))
      status = .failed
      return
    }

    if session.canAddOutput(videoOutput) {
      session.addOutput(videoOutput)

      videoOutput.videoSettings =
        [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

      let videoConnection = videoOutput.connection(with: .video)
      videoConnection?.videoOrientation = .portrait
    } else {
      set(error: .cannotAddOutput)
      status = .failed
      return
    }

    status = .configured
  }

  private func configure() {
    checkPermissions()

    sessionQueue.async {
      self.configureCaptureSession()
      self.session.startRunning()
    }
  }

  func set(
    _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
    queue: DispatchQueue
  ) {
    sessionQueue.async {
      self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
    }
  }
}
