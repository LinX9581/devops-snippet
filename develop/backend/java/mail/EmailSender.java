package com.example;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailSender {
    public static void main(String[] args) {
        // 收件人和發件人電子郵件地址
        String to = "";
        String from = "";

        // 使用的郵件伺服器
        String host = "smtp.gmail.com";

        // 設置屬性對象
        Properties properties = System.getProperties();
        properties.setProperty("mail.smtp.host", host);
        properties.setProperty("mail.smtp.port", "587"); // 根據伺服器配置調整端口
        properties.setProperty("mail.smtp.auth", "true");
        properties.setProperty("mail.smtp.starttls.enable", "true");

        // 獲取默認的 Session 對象
        Session session = Session.getDefaultInstance(properties, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("", "");
            }
        });

        try {
            // 創建默認的 MimeMessage 對象
            MimeMessage message = new MimeMessage(session);

            // 設置 From: header field
            message.setFrom(new InternetAddress(from));

            // 設置 To: header field
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            // 設置 Subject: header field
            message.setSubject("This is the Subject Line!");

            // 設置消息正文
            message.setText("This is the actual message");

            // 發送消息
            Transport.send(message);
            System.out.println("Sent message successfully....");
        } catch (MessagingException mex) {
            mex.printStackTrace();
        }
    }
}
