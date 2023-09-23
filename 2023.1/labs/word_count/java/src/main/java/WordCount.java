import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.ReentrantLock;

public class WordCount {
    
    private static ReentrantLock lock = new ReentrantLock();
    private static int count = 0; 
    
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java WordCount <root_directory>");
            System.exit(1);
        }

        String rootPath = args[0];
        File rootDir = new File(rootPath);
        File[] subdirs = rootDir.listFiles();

        if (subdirs != null) {
	    
     	    List<Thread> threads = new ArrayList<>();
	    
	    for (File subdir : subdirs) {
                if (subdir.isDirectory()) {
                    File[] files = subdir.listFiles();
                    if (files != null) {
                        for (File file : files) {
                            if (file.isFile()) {
                                Thread thread = new Thread(new MyThread(file.getAbsolutePath()));
                                threads.add(thread);
                                thread.start();
                            }
                        }
                    }
                }
            }

	    for (Thread thread : threads) {
                try {
                    thread.join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        System.out.println(count);
    }

    private static class MyThread implements Runnable {
        private String filePath;

	MyThread(String filePath){
	    this.filePath = filePath;
	}

	@Override
	public void run(){
	    int localCount = wcFile(filePath);
	    lock.lock();
	    try {
	    	count += localCount;
	    } finally {
	    	lock.unlock();
	    }
	}
    }

    public static int wc(String fileContent) {
        String[] words = fileContent.split("\\s+");
        return words.length;
    }

    public static int wcFile(String filePath) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(filePath));
            StringBuilder fileContent = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                fileContent.append(line).append("\n");
            }

            reader.close();
            return wc(fileContent.toString());

        } catch (IOException e) {
            e.printStackTrace();
            return -1;
        }
    }
}
