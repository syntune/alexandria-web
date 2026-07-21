<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>
<html>
    <head>
        <title>Alexandria Web</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
        <link rel="stylesheet" href="assets/css/main.css" />
        <link rel="stylesheet" href="assets/css/genres.css" />
    </head>

    <body class="is-preload" style="background-color: #212121">
        <%
            if (session.getAttribute("user") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        
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
                            <a href="signup.jsp">Sign up</a>
                            <a href="login.jsp">Login</a>
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
                <a href="browse?genre=biography">Biography</a>
            </nav>
        </div>

        <div class="browse-layout">
            
            <!-- Popular books -->
            <section class="popular-books">
                <h2>Browse Books</h2>

                <div class="book-grid">
                    <c:choose>
                        <c:when test="${not empty books}">
                            <c:forEach var="book" items="${books}">
                                <article class="book-card">
                                    <a href="${pageContext.request.contextPath}/book/${book.bookId}">
                                        <div class="book-cover-wrap">
                                            <img src="images/books-cover/${book.image}" alt="${book.title}" class="book-cover">
                                        </div>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/book/${book.bookId}">
                                        <h3 class="book-title">${book.title}</h3>                                        
                                    </a>
                                    
                                    <p class="book-author">
                                        ${book.authorName}
                                    </p>

                                    <p class="book-description">
                                        <c:choose>
                                            <c:when test="${not empty book.description and book.description.length() > 20}">
                                                ${book.description.substring(0, 20)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${book.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </article>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <p>No books found.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <!-- All genres -->
            <aside class="genre-sidebar">
                <h2>Genres</h2>

                <div class="genre-sidebar-grid">
                    <a href="browse" class="genre-link">All</a>

                    <c:forEach var="genre" items="${genres}">
                        <a href="browse?genre=${genre.name}" class="genre-link">
                            ${genre.name}
                        </a>
                    </c:forEach>
                </div>
            </aside>
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

    </body>
</html>