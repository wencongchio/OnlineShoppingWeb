<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <% 
        String shoppingCartID = null;
        double totalPrice = 0;
        
        Class.forName("com.mysql.jdbc.Driver");
        java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/skinbliss", "root", "root");
        java.sql.Statement stmt = con.createStatement();
        
        String sql = "SELECT id FROM cart WHERE status = \'incomplete\'; ";
        ResultSet rs = stmt.executeQuery(sql);
        if (rs.next()){
            shoppingCartID = rs.getString("id");
        }
        else{
            String insertCart = "INSERT INTO cart (status) VALUES ('incomplete');";
            stmt.executeUpdate(insertCart);
            ResultSet shoppingCart = stmt.executeQuery(sql);
            while(shoppingCart.next()){
                shoppingCartID = shoppingCart.getString("id");
            }
        }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping Cart | Skin Bliss</title>
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
        <%
            String retrieveProduct = "SELECT * FROM cart_product NATURAL JOIN product WHERE cart_id = \'" + shoppingCartID + "\';" ;
            ResultSet productList =  stmt.executeQuery(retrieveProduct);
            if (!productList.isBeforeFirst()){%>
                <div class="shoppingCart">
                    <center><h1 class="m-5">No item in shopping cart!</h1></center>
                </div>
            <%stmt.close();}
            else{%>
                <div class="shoppingCart">
                    <center><h1 class="m-5">Shopping Cart</h1></center>
                
                    <table>
                        <tr>
                            <th colspan="2">
                                Product
                            </th>
                            <th class="text-center">
                                Quantity
                            </th>
                            <th class="text-center">
                                Price
                            </th>
                            <th class="text-center">
                                Remove
                            </th>
                        </tr>
            
                <%
                    while (productList.next()){
                        String productID = productList.getString("product_id");
                        String productName = productList.getString("name");
                        double productPrice = productList.getDouble("price");
                        String imagePath = productList.getString("image_path");
                        int quantity = productList.getInt("quantity");
                        
                        totalPrice = totalPrice + (quantity*productPrice);
                %>
                        <tr>
                            <td class="cartProductImage">
                                <img src= "<%= imagePath %>" alt="Avatar" width="100%">
                            </td>
                            <td class="cartProductName">
                                <%= productName %>
                            </td>
                            <td class="cartProductQuantity text-center">
                                <% if (quantity == 1){%>
                                    <button type="submit" disabled><i class="fa fa-minus"></i></button>
                                <%} else{%>
                                    <form action="UpdateQuantity" method="POST" id="<%= productID + "d" %>">
                                        <input type="hidden" name="productID" value="<%= productID %>">
                                        <input type="hidden" name="cartID" value="<%= shoppingCartID %>">
                                        <input type="hidden" name="quantity" value="<%= quantity - 1 %>">
                                    </form>
                                    <button type="submit" form="<%= productID + "d" %>"><i class="fa fa-minus"></i></button>
                                <%}%>
                                <input type="text" value="<%= quantity %>" readonly>
                                
                                <form action="UpdateQuantity" method="POST" id="<%= productID + "i" %>">
                                    <input type="hidden" name="productID" value="<%= productID %>">
                                    <input type="hidden" name="cartID" value="<%= shoppingCartID %>">
                                    <input type="hidden" name="quantity" value="<%= quantity + 1 %>">
                                </form>
                                <button type="submit" form="<%= productID + "i" %>"><i class="fa fa-plus"></i></button>
                            </td>
                            <td class="cartProductPrice text-center">
                                RM <%= String.format("%,.2f", quantity * productPrice) %>
                            </td>
                            <td class="cartRemove text-center">
                                <form action="RemoveItem" method="POST"><input type="hidden" name="productID" value="<%= productID %>"><input type="hidden" name="cartID" value="<%= shoppingCartID %>"><button type="submit"><i class="fa fa-close"></i></button></form>
                            </td>
                        </tr>
                    <%}%>
                    <tr class="totalPrice">
                        <td class="text-right" colspan="3">
                            <b>Total:</b> 
                        </td>
                        <td class="text-center">
                            <b>RM <%= String.format("%,.2f", totalPrice) %></b>
                        </td>
                    </tr>
                    </table>
                    <div class="deliveryForm">
                        <div class="row m-3">
                            <h1>Delivery Information</h1>
                        </div>
                        <form action="orderConfirmation.jsp" method="POST">
                            <input type="hidden" name="cartID" value="<%= shoppingCartID %>">
                            <div class="row m-3">
                                <div class="col-md-6">
                                    Name:
                                    <input type="text" name="name" placeholder="Please enter your name" required>
                                </div>
                                <div class="col-md-6">
                                    Address:
                                    <input type="text" name="address" placeholder="Please enter your address" required>
                                </div>
                            </div>
                            <div class="row m-3">
                                <div class="col-md-6">
                                    Email:
                                    <input type="email" name="email" placeholder="Please enter your email" required>
                                </div>
                                <div class="col-md-6">
                                    Postcode:
                                    <input type="text" name="postcode" placeholder="Please enter your postcode" required>
                                </div>
                            </div>
                            <div class="row m-3">
                                <div class="col-md-6">
                                    Phone Number:
                                    <input type="text" name="phoneNo" placeholder="Please enter your phone number" required>
                                </div>
                                <div class="col-md-6">
                                    State:
                                    <input type="state" name="state" placeholder="Please enter your state" required>
                                </div>
                            </div>
                            <div class="row mt-4 m-3">
                                <div class="col-md-6 offset-md-6">
                                    <input type="submit" value="Checkout">
                                </div>
                            </div>
                        </form>         
                    </div>
                </div>
            <%stmt.close();}
        %>
        
        <div id="footer"></div>
    </body>
</html>
