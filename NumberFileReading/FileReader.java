import java.io.File;
import java.io.FileInputStream;
import processing.core.PApplet;

public class FileReader {

  File file;

  int index = 0;

  public FileReader(String fileName) {

    file = new File("C:/Users/Turt/Documents/ProcessingGit/NumberFileReading/" + fileName);
  }

  public int readBytes(int numberOfBytes) {
    try {
      FileInputStream reader = new FileInputStream(file);
      reader.skip(index);
      int number = 0;

      for (int i = 0; i < numberOfBytes; i++) {
        number = number | (reader.read() << (8 * (numberOfBytes - 1 - i)));
      }
      index += numberOfBytes;
      return number;
    } 
    catch(Exception e) {
      PApplet.println(e);
    }

    return -1;
  }

  public void setIndex(int n) {
    index = n;
  }
}