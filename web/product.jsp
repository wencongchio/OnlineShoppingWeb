<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <% 
        String categoryID = request.getParameter("category");
        String updateProductID = request.getParameter("productID");
        
        String sortBy = "name";
        String dir = "asc";
        
        if (!(request.getParameter("sort") == null)){
            sortBy = request.getParameter("sort");
        }
        
        if (!(request.getParameter("dir") == null)){
            dir = request.getParameter("dir");
        }
        
        String categoryName = null;
        String shoppingCartID = null;
        
        Class.forName("com.mysql.jdbc.Driver");
        java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/skinbliss", "root", "root");
        java.sql.Statement stmt = con.createStatement();
        
        String sql1 = "SELECT name FROM category WHERE category_id = \'" + categoryID + "\';";
        ResultSet rs1 = stmt.executeQuery(sql1);
        while(rs1.next()){
            categoryName = rs1.getString("name");
        }
        
        String sql2 = "SELECT id FROM cart WHERE status = \'incomplete\'; ";
        ResultSet rs2 = stmt.executeQuery(sql2);
        if (rs2.next()){
            shoppingCartID = rs2.getString("id");
        }
        else{
            String insertCart = "INSERT INTO cart (status) VALUES ('incomplete');";
            stmt.executeUpdate(insertCart);
            ResultSet shoppingCart = stmt.executeQuery(sql2);
            while(shoppingCart.next()){
                shoppingCartID = shoppingCart.getString("id");
            }
        }
    %>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= categoryName %> | Skin Bliss</title>
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
        <div id="header"></div>
        <div class="productContent">
            <center>
                <h1 class="mt-5 mb-3">
                    <% 
                        char[] chars = categoryName.toUpperCase().toCharArray();
                        out.print(chars[0]);
                        for (int i = 1; i<chars.length; i++){
                            out.print("&nbsp" + chars[i]);
                        }
                    %>
                </h1>
            </center>
            <div class="productContainer col-md-8 offset-md-2 mt-5 mb-5 row">
                <div class="col-md-12 text-right">
                    <select name="sort" onchange="window.location.href=this.value">
                        <option value="product.jsp?category=<%=categoryID%>&sort=name">Name: Ascending</option>
                        <option value="product.jsp?category=<%=categoryID%>&sort=name&dir=desc">Name: Descending</option>
                        <option value="product.jsp?category=<%=categoryID%>&sort=price">Price: Low to High</option>
                        <option value="product.jsp?category=<%=categoryID%>&sort=price&dir=desc">Price: High to Low</option>
                    </select>
                </div>
                
                <% 
                    Class.forName("com.mysql.jdbc.Driver");
                    String sql3 = "SELECT * FROM product WHERE category_id = \'" + categoryID + "\' ORDER BY " + sortBy + " " + dir;
                    ResultSet rs3 = stmt.executeQuery(sql3);
                    while(rs3.next()){
                        String productID = rs3.getString("product_id");
                        String productName = rs3.getString("name");
                        String productDesc = rs3.getString("description");
                        double productPrice = rs3.getDouble("price");
                        String imagePath = rs3.getString("image_path");
                        
                %>
                <div class="col-md-4 product">
                    <div class="card">
                        <div class="text-center">
                            <img src= "<%= imagePath %>" alt="Avatar">
                        </div>
                        <div class="container">
                            <p class="productName" title="<%= productName %>"><%= productName %></p> 
                            <p class="productDesc" title="<%= productDesc %>"><%= productDesc %></p>
                            <p class="productPrice">RM <%= String.format("%,.2f", productPrice) %></p>
                            <form>
                                <input type="hidden" name="productID" value="<%= productID%>">
                                <input type="hidden" name="category" value="<%= categoryID%>">
                                <input id = "addToCart" type="submit" value="ADD TO CART">
                            </form>
                        </div>
                    </div>
                </div>
                
                <%}
                %>
            </div>
        </div>
        <div id="successMessage">
            Successfully added to the cart!
        </div>
        <%
            if (!(updateProductID == null)){
                String sql4 = "SELECT * FROM cart_product WHERE cart_id = \'" + shoppingCartID + "\' AND product_id = \'" + updateProductID + "\';";
                ResultSet existingProduct = stmt.executeQuery(sql4);
                if (existingProduct.next()){
                    int quantity = existingProduct.getInt("quantity") + 1;
                    String updateQuantity = "UPDATE cart_product SET quantity = " + quantity + " WHERE cart_id = \'" + shoppingCartID + "\' AND product_id = \'" + updateProductID + "\';";
                    stmt.executeUpdate(updateQuantity);%>
                    <script>
                        document.getElementById("successMessage").style.display = "block";
                        setTimeout(function(){ document.getElementById("successMessage").style.display = "none"; }, 2000);
                    </script>
                <%}
                else{
                    String insertProduct = "INSERT INTO cart_product (cart_id, product_id, quantity) VALUES (\'" + shoppingCartID + "\', \'" + updateProductID + "\', 1);";
                    stmt.executeUpdate(insertProduct); %>
                    <script>
                        document.getElementById("successMessage").style.display = "block";
                        setTimeout(function(){ document.getElementById("successMessage").style.display = "none"; }, 2000);
                    </script>
                <%}
            }
            stmt.close();
        %>
        <div id="footer"></div>
    </body>
</html>
