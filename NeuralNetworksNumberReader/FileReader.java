import java.io.File;
import java.io.FileInputStream;
import processing.core.PApplet;

public class FileReader {

  File file;
  int index = 0;

  byte[] fileInfo;

  public FileReader(String fileName) {

    file = new File("C:/Users/Turt/Documents/ProcessingGit/NeuralNetworksNumberReader/" + fileName);
    fileInfo = readFile();
  }

  public byte[] readFile() {
    try {

      FileInputStream reader = new FileInputStream(file);

      byte[] fileInfo = new byte[reader.available()];

      reader.read(fileInfo);

      reader.close();
      return fileInfo;
    } 
    catch(Exception e) {
    }

    return null;
  }

  public int readBytes(int numberOfBytes) {
    int number = 0;

    for (int i = 0; i < numberOfBytes; i++) {
      number = number | (fileInfo[index + i] << (8 * (numberOfBytes - 1 - i)));
    }
    
    index += numberOfBytes;
    return number;
  }

  public void setIndex(int n) {
    index = n;
  }
  
  public byte getByte(int index) {
   return fileInfo[index]; 
  }
}