<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>
<html>
    <head>
        <title>Alexandria Web</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
        <link rel="stylesheet" href="assets/css/main.css" />
    </head>

    <body class="is-preload">
        <%
            if (session.getAttribute("user") != null) {
                response.sendRedirect("index.jsp");
                return;
            }
        %>
        
        <!-- Navigation -->
        <header id = "site-header" class="site-header">
            <div class="top-bar">
                <nav class="top-nav">
                    <a href="index.jsp">Home</a>
                    <a href="browse">Browse Books</a>
                </nav>
                 <nav class="top-nav" id ="nav-spacer"> </nav> 
                 
                <nav class="top-nav user-nav">
                    <a href="signup">Sign up</a>
                    <a href="login">Login</a>
                </nav>
            </div>
            <div id = "main-bar" class="main-bar">
                <img id = "logo" src="images/alexandria-white3.svg" alt="logo">
            </div>
            <div class="category-bar">

            </div>
        </header>

        <!-- Sign In -->
        <div id = "signup-tab">
            <p>
                Libraries should be accessible with just a button click.
                Discover thousands of books from your favorite authors with
                one affordable subscription.
            </p>
            <form id="login-form" method="post" action="signup">
                <input type="text" name="username" id="username" placeholder="Username" required/>
                <input type="password" name="password" id="password" placeholder="Password" required/>
                <input type="submit" value="Sign up" />
            </form>

            <p id="signup-link">
                New to the library?
                <a href="signup.html">Sign up here!</a>
            </p>
        </div>
        <!-- Footer -->
        <footer id="footer">
            <ul class="icons">
                <li>
                    <a href="https://github.com/syntune"
                       class="icon brands fa-github" target="_blank">
                        <span class="label">GitHub</span>
                    </a>
                </li>
            </ul>
        </footer>

        <!-- Scripts -->
        <script src="assets/js/main.js"></script>

    </body>
</html>