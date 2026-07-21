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

    <body class="is-preload" style="background-color: #212121">

        <!-- Navigation -->
        <header id="site-header" class="site-header">

            <div class="top-bar">
                <nav class="top-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user and sessionScope.user.roleId > 1}">
                            <a href="index.jsp">Home</a>
                            <a href="browse">Browse Books</a>
                            <a href="admin">Admin</a>
                        </c:when>

                        <c:otherwise>
                            <a href="index.jsp">Home</a>
                            <a href="browse">Browse Books</a>
                        </c:otherwise>
                    </c:choose>
                </nav>

                <nav class="top-nav" id="nav-spacer"></nav>

                <nav class="top-nav user-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu">
                                <button class="user-button" type="button">
                                    ${sessionScope.user.username}
                                </button>

                                <div class="user-dropdown">
                                    <a href="logout">Logout</a>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <a href="signup">Sign up</a>
                            <a href="login">Login</a>
                        </c:otherwise>
                    </c:choose>
                </nav>
            </div>

            <div id="main-bar" class="main-bar">
                <img id="logo" src="images/alexandria-white3.svg" alt="Alexandria logo">

                <form id="search-form" method="get" action="browse">
                    <input id="search-text" type="text" name="query" placeholder="Browse books."/>
                    <button type="submit">Search</button>
                </form>
            </div>

        </header>

        <!-- Genre bar -->
        <div class="genre-tab">
            <nav class="top-nav">
                <a href="browse?genre=fiction">Fiction</a>
                <a href="browse?genre=science">Science</a>
                <a href="browse?genre=history">History</a>
                <a href="browse?genre=programming">Programming</a>
                <a href="browse?genre=manga">Manga</a>
            </nav>
        </div>

        <!-- Hero section -->
        <section class="hero-section">
            <div class="hero-content">
                <h1>Read anytime, anywhere!</h1>
                <p>
                    Discover and explore your digital library with easy access to your favorite books.
                </p>
                <a class="hero-button" href="browse">Start reading</a>
            </div>
        </section>

        <!-- Feature section -->
        <section class="intro-section">
            <div class="intro-card">
                <div class="intro-item">
                    <h3>Book Collection</h3>
                    <p>Explore a variety of books across different genres and categories.</p>
                </div>

                <div class="intro-item">
                    <h3>Easy Access</h3>
                    <p>Browse and read available books through a simple and user-friendly interface.</p>
                </div>

                <div class="intro-item">
                    <h3>Read Anywhere</h3>
                    <p>Access your digital books whenever you want from any supported device.</p>
                </div>


                <div class="intro-item">
                    <h3>Simple Experience</h3>
                    <p>Enjoy a clean and straightforward way to discover and read books online.</p>
                </div>
            </div>
        </section>

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

    </body>
</html>