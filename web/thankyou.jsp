<%-- 
    Document   : thankyou
    Created on : Mar 25, 2018, 2:47:55 PM
    Author     : JJ
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thank You | Skin Bliss</title>
        <link rel="shortcut icon" type="image/png" href="images/favicon.png">
        <link href="https://fonts.googleapis.com/css?family=Poiret+One" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css"> 
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script> 
            $(function(){
              $("#header").load("header.jsp"); 
              $("#footer").load("footer.html"); 
            });
        </script>
    </head>
    <body>
        <% 
            String name = request.getParameter("name");
            String phoneNo = request.getParameter("phoneNo");
            String email = request.getParameter("email");
            String feedback = request.getParameter("feedback");
            String information = request.getParameter("information");

            Class.forName("com.mysql.jdbc.Driver");
            java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/skinbliss", "root", "root");
            java.sql.Statement stmt = con.createStatement();

            String sql1 = "INSERT INTO feedback (name, phone_no, email, feedback, information) VALUES(\'" + name + "\', \'" + phoneNo + "\', \'" + email + "\', \'" + feedback + "\', \'" + information + "\');";
            stmt.executeUpdate(sql1);
            
            stmt.close();
        
        %>
        <div id="header"></div>
        <div class="content">
            <center>Dear <b><%= request.getParameter("name") %></b>, your feedback has been submitted. 
                <br>Thank you for having taken your time to provide us with your valuable feedback!
                <br>We hope to assist you more in the future!
            </center>
        </div>
        <div id="footer"></div>
    </body>
</html>
