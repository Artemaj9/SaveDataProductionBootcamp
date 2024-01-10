//
//  ContentView.swift
//  SaveDataProductionBootcamp
//
//  Created by Artem on 10.01.2024.
//

import SwiftUI


class LocalFileManaer {
    
    static let instance = LocalFileManaer()
    
    func saveImage(image: UIImage, name: String) {
        
        guard
            let data = image.pngData(),
            let path = getPathForImage(name: name) else {
            print("Error getting data")
            return
        }
        
       // let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
       // let path = directory?.appendingPathComponent("\(name).png")
       // print(directory)
        //print(path)
//        guard
//            let path = FileManager
//                .default
//                .urls(for: .documentDirectory, in: .userDomainMask)
//                .first?
//                .appendingPathComponent("\(name).png") else {
//            print("Error getting path")
//            return
//        }
        
        do {
            try data.write(to: path)
            print("Success saving!")
        } catch let error {
            print("Error saving. \(error)")
        }
     }
    
    func getImage(name: String) -> UIImage? {
        guard let path = getPathForImage(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else {
            print("Error getting path")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(name).png") else {
            print("Error getting path")
            return nil
        }
        
        return path
    }
}

class FileManagerViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let imageName: String = "zvezdopad"
    let manager  = LocalFileManaer.instance
    
    func getImageFromAssetsFolder() {
        image = UIImage(named: imageName)
    }
    
    func getImageFromFileManager() {
        image = manager.getImage(name: imageName)
    }
    
    
    func saveImage() {
        guard let image = image else { return }
        manager.saveImage(image: image, name: imageName)
    }
    
    init() {
      //getImageFromAssetsFolder()
    getImageFromFileManager()
    }
}

struct FileManagerBootcamp: View {
    
    @StateObject var vm = FileManagerViewModel()
    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipped()
                    .cornerRadius(10)
                
                Button {
                    vm.saveImage()
                } label: {
                    Text("Save to FM")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerBootcamp()
    }
}
