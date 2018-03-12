import java.io.File;
import java.io.FileInputStream;
import processing.core.PApplet;

public class FileReader {

  File file;
  int index = 0;

  public int[] fileInfo;

  public FileReader(String fileName) {

    file = new File("C:/Users/Andy R/Documents/ProcessingGit/ProcessingCode/NeuralNetworksNumberReader/" + fileName);
    byte[] fileInfoB = readFile();
    fileInfo = new int[fileInfoB.length];
    for(int i = 0; i < fileInfoB.length; i++) {
      fileInfo[i] = (int)fileInfoB[i];
    }
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
  
  public int getByte(int index) {
   return fileInfo[index]; 
  }
}