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
            String address = request.getParameter("address");
            String postcode = request.getParameter("postcode");
            String state = request.getParameter("state");
            String cartID = request.getParameter("cartID");

            Class.forName("com.mysql.jdbc.Driver");
            java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/skinbliss", "root", "root");
            java.sql.Statement stmt = con.createStatement();

            String sql1 = "INSERT INTO orders (customer_name, phone_no, email, address, postcode, state, cart_id) VALUES(\'" + name + "\', \'" + phoneNo + "\', \'" + email + "\', \'" + address + "\', \'" + postcode + "\', \'" + state + "\', \'" + cartID + "\');";
            stmt.executeUpdate(sql1);
            
            String sql2 = "UPDATE cart SET status = \'complete\' WHERE id = \'" + cartID + "\';";
            stmt.executeUpdate(sql2);
            
            stmt.close();
        
        %>
        <div id="header"></div>
        <div class="content">
            <center>Dear <b><%= request.getParameter("name") %></b>, your order has been recorded.
                <br>Thank you for your purchase! We're getting your order ready to be shipped.
            </center>
        </div>
        <div id="footer"></div>
    </body>
</html>
