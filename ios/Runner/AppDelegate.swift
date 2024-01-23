import UIKit
import Flutter
import Vision

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "ocr_plugin"
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    guard let controller = window?.rootViewController as? FlutterViewController else {
        fatalError("rootViewController is not type FlutterViewController")
    }
    let ocrChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
    
    ocrChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "getOCRByPath":
        self?.handleOCRByPath(call: call, result: result)
      case "getOCRByBytes":
        self?.handleOCRByBytes(call: call, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleOCRByPath(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? Dictionary<String, Any>,
          let imagePath = args["imagePath"] as? String,
          let cgImage = UIImage(contentsOfFile: imagePath)?.cgImage else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for OCR by path", details: nil))
      return
    }

    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
    let request = VNRecognizeTextRequest { (request, error) in
      if let error = error {
        result(FlutterError(code: "OCR_ERROR", message: error.localizedDescription, details: nil))
        return
      }
      guard let results = request.results as? [VNRecognizedTextObservation] else {
        result(FlutterError(code: "OCR_ERROR", message: "No text found", details: nil))
        return
      }

      let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
      result(recognizedText)
    }
    
    do {
      try requestHandler.perform([request])
    } catch {
      result(FlutterError(code: "REQUEST_HANDLER_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func handleOCRByBytes(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? Dictionary<String, Any>,
          let bytes = args["imageBytes"] as? FlutterStandardTypedData,
          let cgImage = UIImage(data: bytes.data)?.cgImage else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for OCR by bytes", details: nil))
      return
    }

    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
    let request = VNRecognizeTextRequest { (request, error) in
      if let error = error {
        result(FlutterError(code: "OCR_ERROR", message: error.localizedDescription, details: nil))
        return
      }
      guard let results = request.results as? [VNRecognizedTextObservation] else {
        result(FlutterError(code: "OCR_ERROR", message: "No text found", details: nil))
        return
      }

      let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
      result(recognizedText)
    }
    
    do {
      try requestHandler.perform([request])
    } catch {
      result(FlutterError(code: "REQUEST_HANDLER_ERROR", message: error.localizedDescription, details: nil))
    }
  }
}
