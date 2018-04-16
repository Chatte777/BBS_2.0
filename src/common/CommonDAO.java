package common;

import java.io.FileWriter;
import java.net.InetAddress;
import java.text.SimpleDateFormat;

public class CommonDAO {

    public static void writeContentLog(String action, String content){
    try {
        String location;
        InetAddress ip = InetAddress.getLocalHost();
        if (ip.toString().equals("KoreaUniv-PC/192.168.219.90"))
            location = "E:\\Dropbox\\Workspace\\IntelliJ\\BBS\\BBS_2.0\\out\\log\\contentLog.txt";
        else location = "C:\\Users\\IMTSOFT\\Documents\\contentLog.txt";

        long curTimeLong = System.currentTimeMillis();
        SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        String curTimeStr = dayTime.format(new java.sql.Date(curTimeLong));

        FileWriter writer = new FileWriter(location, true);
        writer.write(curTimeStr + "\t"+ action +"\r\n" + content + "\r\n\r\n");
        writer.close();
    } catch (Exception innerE) {
        innerE.printStackTrace();
    }
    return;
    }
}
