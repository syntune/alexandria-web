<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE HTML>
<html>
    <!--    This jsp is special because it is directed from Book servlet, which uses slugs-->
    <head>
        <title>Alexandria Web</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
        <link rel="stylesheet" href="${ctx}/assets/css/main.css" />
        <link rel="stylesheet" href="${ctx}/assets/css/genres.css" />
        <link rel="stylesheet" href="${ctx}/assets/css/book.css" />
    </head>

    <body class="is-preload" style="background-color: #212121">
        <!-- Navigation -->
        <header id="site-header" class="site-header">

            <div class="top-bar">
                <nav class="top-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user and sessionScope.user.roleId > 1}">
                            <a href="${ctx}/index.jsp">Home</a>
                            <a href="${ctx}/browse">Browse Books</a>
                            <a href="${ctx}/admin">Admin</a>
                        </c:when>

                        <c:otherwise>
                            <a href="${ctx}/index.jsp">Home</a>
                            <a href="${ctx}/browse">Browse Books</a>
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
                            <a href="${ctx}/signup.jsp">Sign up</a>
                            <a href="${ctx}/login.jsp">Login</a>
                        </c:otherwise>
                    </c:choose>
                </nav>
            </div>

            <div id="main-bar" class="main-bar">
                <img id="logo" src="${ctx}/images/alexandria-white3.svg" alt="Alexandria logo">

                <form id="search-form" method="get" action="${ctx}/browse">
                    <input id="search-text" type="text" name="query" placeholder="Browse books."/>
                    <button type="submit">Search</button>
                </form>
            </div>

        </header>

        <!-- Genre bar -->
        <div class="genre-tab">
            <nav class="top-nav">
                <a href="${ctx}/browse?genre=fiction">Fiction</a>
                <a href="${ctx}/browse?genre=science">Science</a>
                <a href="${ctx}/browse?genre=history">History</a>
                <a href="${ctx}/browse?genre=programming">Programming</a>
                <a href="${ctx}/browse?genre=manga">Manga</a>
                <a href="${ctx}/pricing.jsp">Student Plan</a>
            </nav>
        </div>

        <!--Book details-->
        <section class="book-detail-page">
            <div class="book-detail-header">
                <div class="book-cover-box">
                    <img 
                        src="${ctx}/images/books-cover/${book.image}" 
                        alt="${book.title}" 
                        class="book-detail-cover"
                        />
                </div>

                <div class="book-info-box">
                    <h1 class="book-detail-title">${book.title}</h1>

                    <div class="book-meta-row">
                        <span class="book-meta-label">Author</span>
                        <span class="book-meta-value">${author}</span>
                    </div>
                    
                    <div class="book-meta-row">
                        <span class="book-meta-label">Year</span>
                        <span class="book-meta-value">${book.year}</span>
                    </div>

                    <div class="book-meta-row">
                        <span class="book-meta-label">Genres</span>

                        <span class="book-meta-value genre-list">
                            <c:forEach var="genre" items="${genres}" varStatus="status">
                                <a href="${ctx}/browse?genre=${genre.name}" class="genre-link-detail">
                                    ${genre.name}
                                </a>

                                <c:if test="${not status.last}">
                                    <span class="genre-separator"> - </span>
                                </c:if>
                            </c:forEach>
                        </span>
                    </div>

                    <div class="book-action-row">
                        <a 
                            href="${ctx}/assets/pdf/${book.contentPath}" 
                            class="read-button"
                            target="_blank"
                            >
                            Read
                        </a>
                    </div>
                </div>
            </div>

            <div class="book-content-section">
                <h2>Content of ${book.title}</h2>

                <p class="book-description-full">
                    ${book.description}
                </p>
            </div
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