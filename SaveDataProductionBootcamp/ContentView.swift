//
//  ContentView.swift
//  SaveDataProductionBootcamp
//
//  Created by Artem on 10.01.2024.
//

import SwiftUI


class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    let folderName = "MyApp_Images"
    init() {
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded() {
        guard let path = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .path else {
            return
        }
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
                print("Success creating folder.")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    
    func deleteFolder() {
        guard let path = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .path else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Success deleting folder")
        } catch let error {
            print("Error deleting folder. \(error)")
        }
    }
    
    func saveImage(image: UIImage, name: String) {
        guard
            let data = image.pngData(),
            let path = getPathForImage(name: name) else {
            print("Error getting data")
            return
        }
        
        do {
            try data.write(to: path)
            print(path)
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
    
    func deleteImage(name: String) {
        guard let path = getPathForImage(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else {
            print("Error getting path")
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Succesfully deleted!")
        } catch let error {
            print("Error deleting image. \(error)")
        }
    }
    
    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathComponent("\(name).png") else {
            print("Error getting path")
            return nil
        }
        
        return path
    }
}

class FileManagerViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var infoMessage: String = ""
    let imageName: String = "Zvezdopad"
    let manager  = LocalFileManager.instance
    
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
    
    func deleteImage() {
        manager.deleteImage(name: imageName)
    }
    
    init() {
    getImageFromAssetsFolder()
  //  getImageFromFileManager()
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
                HStack {
                    Button {
                        vm.saveImage()
                    } label: {
                        Text("Save to FM")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        vm.deleteImage()
                    } label: {
                        Text("Delete from FM")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Text(vm.infoMessage)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.pink)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerBootcamp()
    }
}
