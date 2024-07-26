//
//  File.swift
//  
//
//  Created by Colin Teahan on 7/26/24.
//

import Figlet
import Foundation
import ArgumentParser
import CoreGraphics
import ImageIO

@main
struct FigletTool: ParsableCommand {
  @Option(help: "Specify local image url")
  public var image: String
  
  private enum TranscodingType {
    case HEIC
    case JPEG
    case PNG
  }
  
  private enum Exceptions: Error {
    case urlNotValid
    case canNotAccessLocalFile
    case failedToCreateSource
    case failedToCreateDestination
    case failedToFinalizeTranscoding
    case transcodingFailed
  }

  public func run() throws {
    Figlet.say("Swift HEIC");
    
    let imageURL = URL(fileURLWithPath: self.image)
    print("Transcoding source: \(imageURL)")
    
    guard let transcodedURL = try? self.transode(image: imageURL.standardizedFileURL, to: .JPEG) else {
      print("Transcoding failed.");
      return
    }
    
    print(transcodedURL.absoluteString)
  }
  
  private func getPathExtension(for type: TranscodingType) -> String {
    return switch type {
    case .HEIC: "heic"
    case .JPEG: "jpeg"
    case .PNG: "png"
    }
  }
  
  private func transode(image sourceURL: URL, to type: TranscodingType) throws -> URL? {
    let canAccess = sourceURL.startAccessingSecurityScopedResource()
    guard canAccess == true else { throw Exceptions.canNotAccessLocalFile }
    defer { sourceURL.stopAccessingSecurityScopedResource() }
    print("Transcoding access granted: \(canAccess)")
    print("Transcoding to (\(type))")
    let pathExtension = self.getPathExtension(for: type)
    let outputURL = sourceURL.deletingPathExtension().appendingPathExtension(pathExtension)
    
    do {
      guard let source = CGImageSourceCreateWithURL(sourceURL as CFURL, nil) else {
        throw Exceptions.failedToCreateSource
      }
      
      let mimeType = "public.\(pathExtension)" as CFString
      let options: [CFString: Any] = [
        kCGImageDestinationLossyCompressionQuality: 1.0,
      ]
      
      guard let output = CGImageDestinationCreateWithURL(outputURL as CFURL, mimeType, 1, nil) else {
        throw Exceptions.failedToCreateDestination
      }
      
      CGImageDestinationAddImageFromSource(output, source, 0, options as CFDictionary)
      
      guard CGImageDestinationFinalize(output) else {
        throw Exceptions.failedToFinalizeTranscoding
      }
      
      print("Transcoding output: \(outputURL)")
      return outputURL
    } catch {
      print("Transcoding error: \(error)")
      return nil
    }
  }
}
