<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Home | Skin Bliss</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="shortcut icon" type="image/png" href="images/favicon.png">
        <link href="https://fonts.googleapis.com/css?family=Poiret+One" rel="stylesheet">
        <link rel="stylesheet" type = "text/css" href = "css/style.css">
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
        <div id="header"></div>
        <div class="categories">
            <div class="mt-5 mb-3"><center><h1><b>Our Products</b></h1></center></div>
            <div class="col-md-10 offset-md-1 row mt-5 mb-5 text-center position-static">
                <%
                    Class.forName("com.mysql.jdbc.Driver");
                    java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/skinbliss", "root", "root");
                    java.sql.Statement stmt = con.createStatement();
                    
                    String sql = "SELECT * FROM category";
                    ResultSet rs = stmt.executeQuery(sql);
                    while(rs.next()){
                        String categoryID = rs.getString("category_id");
                        String categoryName = rs.getString("name");
                        String imagePath = rs.getString("image_path");
                %>
                <div class="col-md-3 position-static categories-container">
                    <div class="col-md-12 position-static">
                        <a href="product.jsp?category=<%=categoryID%>"><img src="<%=imagePath%>" alt="facemask"></a>
                    </div>
                    <div class="col-md-12 shopnow mt-2 position-static">
                        <a href="product.jsp?category=<%=categoryID%>">SHOP NOW!</a>
                    </div>
                </div>
                <%}%>
            </div>
        </div>
        <div id="footer"></div>
    </body>
</html>
