<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>
<html>
    <head>
        <title>Alexandria Web</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
        <link rel="stylesheet" href="assets/css/main.css" />
        <link rel="stylesheet" href="assets/css/admin.css" />
    </head>

    <body class="is-preload">
        <%
            if (session.getAttribute("user") == null) {
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
                    <a href="admin">Admin</a>
                </nav>
                <nav class="top-nav" id ="nav-spacer"> </nav>                              
            </div>
            <div id = "main-bar" class="main-bar">
                <img id = "logo" src="images/alexandria-white3.svg" alt="logo">
            </div>
            <div class="category-bar">

            </div>
        </header>

        <main class="admin-page">

            <aside class="admin-sidebar">
                <div class="admin-sidebar-title">Admin Panel</div>

                <nav class="admin-menu">
                    <a href="admin?page=users">Users</a>
                    <a href="admin?page=books">Books</a>
                    <a href="admin?page=genres">Genres</a>
                    <a href="admin?page=authors">Authors</a>
                    <a href="admin?page=publishers">Publishers</a>
                </nav>
            </aside>

            <section class="admin-content">

                <div class="admin-heading" id="dashboard">
                    <h1>Admin Dashboard</h1>
                    <p>Manage Alexandria library data from one place.</p>
                </div>

                <div class="admin-grid">

                    <!-- Users Management-->
                    <c:if test="${page == 'users'}">
                        <section class="admin-card" id="users">
                            <div class="admin-card-header">
                                <h2>Users Management</h2>
                                <a href="#" class="admin-add-button" onclick="openUserForm(event, 'insertUserForm')">+ Add New User</a>
                            </div>

                            <div id="insertUserForm" class="admin-insert-form" style="display:none;">
                                <form action="admin?page=${page}" method="post">
                                    <input type="hidden" name="action" value="insert">

                                    <input 
                                        type="text" 
                                        name="username" 
                                        placeholder="Username" 
                                        required
                                        >

                                    <input 
                                        type="password" 
                                        name="password" 
                                        placeholder="Password" 
                                        required
                                        >

                                    <select name="roleId" required>
                                        <option value="">Select Role</option>
                                        <option value="1">User</option>
                                        <option value="2">Admin</option>
                                    </select>

                                    <div class="admin-actions">
                                        <button type="submit" class="admin-action-edit">Confirm</button>
                                        <button type="button" class="admin-action-delete" onclick="closeUserForm('insertUserForm')">Cancel</button>
                                    </div>
                                </form>
                            </div>    

                            <div class="admin-tools">
                                <input type="text" id="userSearch" placeholder="Search users...">
                            </div>

                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Username</th>
                                            <th>Password (Hashed)</th>
                                            <th>Role</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td class ="userName">${user.username}</td>
                                                <td>${user.password}</td>
                                                <c:choose>
                                                    <c:when test="${user.roleId > 1}">
                                                        <td><span class="admin-badge">Admin</span></td>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <td>User</td>
                                                    </c:otherwise>
                                                </c:choose>
                                                <td>
                                                    <div class="admin-actions">
                                                        <a href="admin?page=${page}&action=update" class="admin-action-edit" onclick="openUserForm(event, 'updateUserForm${user.username}')">✎</a>
                                                        <a href="admin?page=${page}&action=delete&username=${user.username}" class="admin-action-delete">🗑</a>
                                                    </div>

                                                    <div id="updateUserForm${user.username}" class="admin-insert-form" style="display:none;">
                                                        <form action="admin?page=${page}&username=${user.username}" method="post">
                                                            <input type="hidden" name="action" value="update">

                                                            <input 
                                                                type="password" 
                                                                name="password" 
                                                                placeholder="Password" 
                                                                required
                                                                >

                                                            <select name="roleId" required>
                                                                <option value="">Select Role</option>
                                                                <option value="1">User</option>
                                                                <option value="2">Admin</option>
                                                            </select>

                                                            <div class="admin-actions">
                                                                <button type="submit" class="admin-action-edit">Confirm</button>
                                                                <button type="button" class="admin-action-delete" onclick="closeUserForm('updateUserForm${user.username}')">Cancel</button>
                                                            </div>
                                                        </form>
                                                    </div> 
                                                </td>     
                                            </tr>

                                        </c:forEach>  
                                    </tbody>
                                </table>
                            </div>                     
                        </section>
                        
                        <script>       
                            const searchBox = document.getElementById("userSearch");
                            const rows = document.querySelectorAll("tbody tr");

                            searchBox.addEventListener("input", () => {
                                const keyword = searchBox.value.trim().toLowerCase();

                                rows.forEach(row => {
                                    const genreName = row.querySelector(".userName").textContent.toLowerCase();
                                    row.hidden = !genreName.includes(keyword);
                                });
                            });
                        </script>
                    </c:if>

                    <!-- Books Management -->
                    <c:if test="${page == 'books'}">
                        <section class="admin-card" id="books">
                            <div class="admin-card-header">
                                <h2>Books Management</h2>
                                <a href="#" class="admin-add-button" onclick="openUserForm(event, 'insertBookForm')">+ Add New Book</a>
                            </div>
                            
                            <div id="insertBookForm" class="admin-insert-form" style="display:none;">
                                <form action="admin?page=${page}" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="insert">

                                    <input 
                                        type="text" 
                                        name="title" 
                                        placeholder="Title" 
                                        required
                                        >
                                    
                                    <input 
                                        type="text" 
                                        name="isbn" 
                                        placeholder="ISBN" 
                                        required
                                        >

                                    
                                    <input 
                                        type="text" 
                                        name="description" 
                                        placeholder="Description" 
                                        required
                                        >
                                    
                                    <input 
                                        type="text" 
                                        name="year" 
                                        placeholder="Year" 
                                        required
                                        >
                                    
                                    <div>
                                        <label>Upload image</label><br>
                                        <input 
                                            type="file"
                                            name="image"
                                            accept="image/*"
                                        >
                                        <br>
                                    </div>
                                    
                                    <div>
                                        <label>Upload PDF</label><br>
                                        <input 
                                            type="file"
                                            name="pdf"
                                            accept="application/pdf"
                                        >
                                        <br>
                                    </div>
                                    
                                    <div>
                                        <label>Genres</label><br>

                                        <c:forEach var="genre" items="${genres}">
                                            <input 
                                                type="checkbox"
                                                id="genre${genre.genreId}"
                                                name="genre"
                                                value="${genre.genreId}">

                                            <label for="genre${genre.genreId}">
                                                ${genre.name}
                                            </label>
                                        </c:forEach>
                                    </div>

                                    <select name="authorId" required>
                                        <option value="">Select Author</option>
                                        <c:forEach var="author" items="${authors}">
                                            <option value=${author.key}>${author.value}</option>    
                                        </c:forEach>
                                    </select>
                                    
                                    <select name="publisherId" required>
                                        <option value="">Select Publisher</option>
                                        <c:forEach var="publisher" items="${publishers}">
                                            <option value=${publisher.key}>${publisher.value}</option>    
                                        </c:forEach>
                                    </select>

                                    <div class="admin-actions">
                                        <button type="submit" class="admin-action-edit">Confirm</button>
                                        <button type="button" class="admin-action-delete" onclick="closeUserForm('insertBookForm')">Cancel</button>
                                    </div>
                                </form>
                            </div>    

                            <div class="admin-tools">
                                <input type="text" id="bookSearch" placeholder="Search books...">
                            </div>

                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Cover</th>
                                            <th>Title</th>
                                            <th>Description</th>
                                            <th>Author</th>
                                            <th>Publisher</th>
                                            <th>Year</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>          
                                        <c:forEach var="book" items="${books}">
                                            <tr>
                                                <td>${book.bookId}</td>
                                                <td><img src="images/books-cover/${book.image}" alt="${book.title}" class="book-cover" style="width: 50%; height: 50%"></td>
                                                <td class="bookName">${book.title}</td>
                                                <td>${book.description}</td>
                                                <td>${book.authorName}</td>
                                                <td>${book.publisherId}</td>
                                                <td>${book.year}</td>
                                                <td>
                                                    <div class="admin-actions">
                                                        <a href="#" class="admin-action-edit" onclick="openUserForm(event, 'updateBookForm${book.bookId}')">✎</a>
                                                        <a href="admin?page=${page}&action=delete&bookId=${book.bookId}&image=${book.image}&pdf=${book.contentPath}"class="admin-action-delete">🗑</a>
                                                    </div>
                                                    
                                                    <div id="updateBookForm${book.bookId}" class="admin-insert-form" style="display:none;">
                                                        <form action="admin?page=${page}&bookId=${book.bookId}" method="post">
                                                            <input type="hidden" name="action" value="update">

                                                            <input 
                                                                type="text" 
                                                                name="title" 
                                                                placeholder="Title" 
                                                                
                                                                >

                                                            <input 
                                                                type="text" 
                                                                name="isbn" 
                                                                placeholder="ISBN" 
                                                                
                                                                >


                                                            <input 
                                                                type="text" 
                                                                name="description" 
                                                                placeholder="Description" 
                                                                
                                                                >

                                                            <input 
                                                                type="text" 
                                                                name="year" 
                                                                placeholder="Year" 
                                                                
                                                                >
                                                            
                                                            <div class="admin-actions">
                                                                <button type="submit" class="admin-action-edit">Confirm</button>
                                                                <button type="button" class="admin-action-delete" onclick="closeUserForm('updateBookForm${book.bookId}')">Cancel</button>
                                                            </div>
                                                        </form>
                                                    </div> 
                                                </td>
                                            </tr>
                                        </c:forEach>  
                                    </tbody>
                                </table>
                            </div>
                        </section>
                         
                        <script>
                            const searchBox = document.getElementById("bookSearch");
                            const rows = document.querySelectorAll("tbody tr");

                            searchBox.addEventListener("input", () => {
                                const keyword = searchBox.value.trim().toLowerCase();

                                rows.forEach(row => {
                                    const genreName = row.querySelector(".bookName").textContent.toLowerCase();
                                    row.hidden = !genreName.includes(keyword);
                                });
                            });
                        </script>
                    </c:if>   

                    <!-- Genres Management -->
                    <c:if test="${page == 'genres'}">
                        <section class="admin-card" id="genres">
                            <div class="admin-card-header">
                                <h2>Genres Management</h2>
                                <a href="#" class="admin-add-button" onclick="openUserForm(event, 'insertGenreForm')">+ Add New Genre</a>
                            </div>

                            <div id="insertGenreForm" class="admin-insert-form" style="display:none;">
                                <form action="admin?page=${page}" method="post">
                                    <input type="hidden" name="action" value="insert">

                                    <input 
                                        type="text" 
                                        name="genre" 
                                        placeholder="Genre Name" 
                                        required
                                        >

                                    <div class="admin-actions">
                                        <button type="submit" class="admin-action-edit" >Confirm</button>
                                        <button type="button" class="admin-action-delete" onclick="closeUserForm('insertGenreForm')">Cancel</button>
                                    </div>
                                </form>
                            </div>  

                            <div class="admin-tools">
                                <input type="text" id = "genreSearch" placeholder="Search genres...">
                            </div>

                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Genre Name</th>
                                            <th>Books Count</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>          
                                        <c:forEach var="genre" items="${genres}">
                                            <tr>
                                                <td class="genreName">
                                                    <span class="admin-badge">${genre.key}</span>
                                                </td>
                                                <td>${genre.value}</td>
                                                <td>
                                                    <div class="admin-actions">
                                                        <a href="admin?page=${page}&action=update" class="admin-action-edit" onclick="openUserForm(event, 'updateGenreForm${genre.key}')">✎</a>
                                                        <a href="admin?page=${page}&action=delete&genre=${genre.key}" class="admin-action-delete">🗑</a>
                                                    </div>
                                                    
                                                    <div id="updateGenreForm${genre.key}" class="admin-insert-form" style="display:none;">
                                                        <form action="admin?page=${page}&genre=${genre.key}" method="post">
                                                            <input type="hidden" name="action" value="update">

                                                            <input 
                                                                type="text" 
                                                                name="new" 
                                                                placeholder="Genre Name" 
                                                                required
                                                                >
                                                            
                                                            <div class="admin-actions">
                                                                <button type="submit" class="admin-action-edit">Confirm</button>
                                                                <button type="button" class="admin-action-delete" onclick="closeUserForm('updateGenreForm${genre.key}')">Cancel</button>
                                                            </div>
                                                        </form>
                                                    </div> 
                                                </td>
                                            </tr>
                                        </c:forEach>  
                                    </tbody>
                                </table>
                            </div>
                        </section>
                                    
                        <script>
                            const searchBox = document.getElementById("genreSearch");
                            const rows = document.querySelectorAll("tbody tr");

                            searchBox.addEventListener("input", () => {
                                const keyword = searchBox.value.trim().toLowerCase();

                                rows.forEach(row => {
                                    const genreName = row.querySelector(".genreName").textContent.toLowerCase();
                                    row.hidden = !genreName.includes(keyword);
                                });
                            });
                        </script>
                    </c:if>  

                    <!-- Authors Management -->
                    <c:if test="${page == 'authors'}">
                        <section class="admin-card" id="authors">
                            <div class="admin-card-header">
                                <h2>Authors Management</h2>
                                <a href="#" class="admin-add-button" onclick="openUserForm(event, 'insertAuthorForm')">+ Add New Author</a>
                            </div>

                            <div id="insertAuthorForm" class="admin-insert-form" style="display:none;">
                                <form action="admin?page=${page}" method="post">
                                    <input type="hidden" name="action" value="insert">

                                    <input 
                                        type="text" 
                                        name="author" 
                                        placeholder="Author Name" 
                                        required
                                        >

                                    <div class="admin-actions">
                                        <button type="submit" class="admin-action-edit">Confirm</button>
                                        <button type="button" class="admin-action-delete" onclick="closeUserForm('insertAuthorForm')">Cancel</button>
                                    </div>
                                </form>
                            </div>      

                            <div class="admin-tools">
                                <input type="text" id="authorSearch" placeholder="Search authors...">
                            </div>

                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Author Name</th>
                                            <th>Books Count</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>          
                                        <c:forEach var="author" items="${authors}">
                                            <tr>
                                                <td class="authorName">
                                                    <span class="admin-badge">${author.key}</span>
                                                </td>
                                                <td>${author.value}</td>
                                                <td>
                                                    <div class="admin-actions">
                                                        <a href="admin?page=${page}&action=update" class="admin-action-edit" onclick="openUserForm(event, 'updateAuthorForm${author.key}')">✎</a>
                                                        <a href="admin?page=${page}&action=delete&author=${author.key}" class="admin-action-delete">🗑</a>
                                                    </div>
                                                    
                                                    <div id="updateAuthorForm${author.key}" class="admin-insert-form" style="display:none;">
                                                        <form action="admin?page=${page}&author=${author.key}" method="post">
                                                            <input type="hidden" name="action" value="update">

                                                            <input 
                                                                type="text" 
                                                                name="new" 
                                                                placeholder="Author Name" 
                                                                required
                                                                >
                                                            
                                                            <div class="admin-actions">
                                                                <button type="submit" class="admin-action-edit">Confirm</button>
                                                                <button type="button" class="admin-action-delete" onclick="closeUserForm('updateAuthorForm${author.key}')">Cancel</button>
                                                            </div>
                                                        </form>
                                                    </div> 
                                                </td>
                                            </tr>
                                        </c:forEach>  
                                    </tbody>
                                </table>
                            </div>
                        </section>
                                    
                         <script>
                            const searchBox = document.getElementById("authorSearch");
                            const rows = document.querySelectorAll("tbody tr");

                            searchBox.addEventListener("input", () => {
                                const keyword = searchBox.value.trim().toLowerCase();

                                rows.forEach(row => {
                                    const genreName = row.querySelector(".authorName").textContent.toLowerCase();
                                    row.hidden = !genreName.includes(keyword);
                                });
                            });
                        </script>
                    </c:if>  

                    <!-- Publishers Management -->
                    <c:if test="${page == 'publishers'}">
                        <section class="admin-card" id="publishers">
                            <div class="admin-card-header">
                                <h2>Publishers Management</h2>
                                <a href="#" class="admin-add-button" onclick="openUserForm(event, 'insertPublisherForm')">+ Add New Publisher</a>
                            </div>

                            <div id="insertPublisherForm" class="admin-insert-form" style="display:none;">
                                <form action="admin?page=${page}" method="post">
                                    <input type="hidden" name="action" value="insert">

                                    <input 
                                        type="text" 
                                        name="publisher" 
                                        placeholder="Publisher Name" 
                                        required
                                        >

                                    <div class="admin-actions">
                                        <button type="submit" class="admin-action-edit">Confirm</button>
                                        <button type="button" class="admin-action-delete" onclick="closeUserForm('insertPublisherForm')">Cancel</button>
                                    </div>
                                </form>
                            </div>        

                            <div class="admin-tools">
                                <input type="text" id="publisherSearch" placeholder="Search publishers...">
                            </div>

                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Publisher Name</th>
                                            <th>Books Count</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>          
                                        <c:forEach var="publisher" items="${publishers}">
                                            <tr>
                                                <td class="publisherName">
                                                    <span class="admin-badge">${publisher.key}</span>
                                                </td>
                                                <td>${publisher.value}</td>
                                                <td>
                                                    <div class="admin-actions">
                                                        <a href="admin?page=${page}&action=update" class="admin-action-edit" onclick="openUserForm(event, 'updatePublisherForm${publisher.key}')">✎</a>
                                                        <a href="admin?page=${page}&action=delete&publisher=${publisher.key}" class="admin-action-delete">🗑</a>
                                                    </div>
                                                    
                                                    <div id="updatePublisherForm${publisher.key}" class="admin-insert-form" style="display:none;">
                                                        <form action="admin?page=${page}&publisher=${publisher.key}" method="post">
                                                            <input type="hidden" name="action" value="update">

                                                            <input 
                                                                type="text" 
                                                                name="new" 
                                                                placeholder="Publisher Name" 
                                                                required
                                                                >
                                                            
                                                            <div class="admin-actions">
                                                                <button type="submit" class="admin-action-edit">Confirm</button>
                                                                <button type="button" class="admin-action-delete" onclick="closeUserForm('updatePublisherForm${publisher.key}')">Cancel</button>
                                                            </div>
                                                        </form>
                                                    </div> 
                                                </td>
                                            </tr>
                                        </c:forEach>  
                                    </tbody>
                                </table>
                            </div>
                        </section>
                                    
                        <script>
                            const searchBox = document.getElementById("publisherSearch");
                            const rows = document.querySelectorAll("tbody tr");

                            searchBox.addEventListener("input", () => {
                                const keyword = searchBox.value.trim().toLowerCase();

                                rows.forEach(row => {
                                    const genreName = row.querySelector(".publisherName").textContent.toLowerCase();
                                    row.hidden = !genreName.includes(keyword);
                                });
                            });
                        </script>
                    </c:if>  
                </div>

            </section>

        </main>

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
        <script src="assets/js/admin.js"></script>

    </body>
</html>