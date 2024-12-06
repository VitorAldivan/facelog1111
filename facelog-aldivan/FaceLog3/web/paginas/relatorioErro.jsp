<%@ page import="java.sql.*" %>
<%
    // Recuperar o ID do relat�rio do campo oculto no formul�rio
    String idParam = request.getParameter("id");
    int id = 0;

    // Verifica se o ID foi fornecido no par�metro
    if (idParam != null && !idParam.isEmpty()) {
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            out.println("<script>alert('ID inv�lido: " + idParam + "');</script>");
        }
    } else {
        out.println("<script>alert('ID n�o fornecido na requisi��o.');</script>");
    }

    // Vari�veis para armazenar os dados do banco
    String titulo = "", descricaoErro = "", inicioIncidente = "", setor = "", urgencia = "";

    // Conex�o com o banco de dados
    String dbUrl = "jdbc:mysql://localhost:3306/facelog";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // Verificar se o formul�rio foi enviado para excluir
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("excluir") != null) {
        try {
            // Conex�o com o banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // Comando SQL para excluir o relat�rio
            String deleteSql = "DELETE FROM pendentes WHERE id_relatorio = ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setInt(1, id);
            int rowsDeleted = stmt.executeUpdate();

            if (rowsDeleted > 0) {
                out.println("<script>alert('Relat�rio exclu�do com sucesso!');</script>");
                response.sendRedirect(request.getContextPath() + "/index.jsp");  // Redirecionar para uma p�gina de sucesso ap�s exclus�o
            } else {
                out.println("<script>alert('Erro ao excluir o relat�rio.');</script>");
            }
        } catch (Exception e) {
            out.println("<script>alert('Erro ao excluir o relat�rio: " + e.getMessage() + "');</script>");
        } finally {
            // Fechar os recursos
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("<script>alert('Erro ao fechar a conex�o: " + e.getMessage() + "');</script>");
            }
        }

    } else {
        // Caso contr�rio, carregue os dados do relat�rio
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            String sql = "SELECT * FROM pendentes WHERE id_relatorio = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                titulo = rs.getString("titulo");
                descricaoErro = rs.getString("decricao_erro");
                inicioIncidente = rs.getString("inicio_incidente");
                setor = rs.getString("setor");
                urgencia = rs.getString("urgencia");
            } else {
                out.println("<script>alert('Nenhum relat�rio encontrado para o ID: " + id + "');</script>");
            }
        } catch (Exception e) {
            out.println("<script>alert('Erro ao buscar o relat�rio: " + e.getMessage() + "');</script>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("<script>alert('Erro ao fechar a conex�o: " + e.getMessage() + "');</script>");
            }
        }
    }
%>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/container.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/menu.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/relatorioErro/relatorioEroo.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/footer.css">
    <script>
        // Fun��o para confirmar a exclus�o e enviar o formul�rio
        function confirmarExclusao() {
            if (confirm("Tem certeza de que deseja excluir este relat�rio?")) {
                document.getElementById('formExclusao').submit();  // Submete o formul�rio ap�s confirma��o
            }
        }
    </script>
</head>
<body>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/icones/facebook.svg" alt="icone do facebook" id="logo-img">
            <h1 id="logo-txt">acelog</h1>
        </div>
        <div class="adicionar_relatorio">
            <a href="${pageContext.request.contextPath}/index.jsp">
                <p>Fechar</p>
            </a>
        </div>
    </header>
    <main>
        <div class="main-container">
            <div class="menu-container">
                <div class="menu-header">Relat�rios</div>
                <input type="checkbox" id="pendentes">
                <label for="pendentes" class="menu-toggle" id="pendentes1">Pendentes
                    <img src="${pageContext.request.contextPath}/icones/seta.svg" alt="seta">
                </label>
                <div class="menu-items">
                    <c:forEach var="relatorio" items="${relatorios}">
                        <div class="menu-item">
                            <a href="#${relatorio.id}">${relatorio.titulo}</a>
                        </div>
                    </c:forEach>
                </div>
                <input type="checkbox" id="resolvidos">
                <label for="resolvidos" class="menu-toggle">Resolvidos
                    <img src="${pageContext.request.contextPath}/icones/seta.svg" alt="seta">
                </label>
            </div>
            <div class="menu-relatorio">
                <h2 class="nome-menu">Relat�rio de erro<hr class="blue-line"></h2>
                <form id="formExclusao" method="POST" action="">
                    <div class="div-status">
                        <h3 class="titulo">T�tulo:<br>
                            <p id="titulo">
                                <%= titulo != null && !titulo.trim().isEmpty() ? titulo : "N�o encontrado" %>
                            </p>
                        </h3>
                        <h3 class="status">Status:<br><p>Pendentes</p></h3>
                    </div>
                    <h3 class="descricao">Descri��o do Erro:<br><br>
                        <p id="descricao">
                            <%= descricaoErro != null && !descricaoErro.trim().isEmpty() ? descricaoErro : "N�o encontrado" %>
                        </p>
                    </h3>
                    <div class="linha-1-relatorio">
                        <h3 class="codigo">C�digo de Identifica��o:<p id="codigo"><%= id %></p></h3>
                        <h3 class="inicio-incidente">In�cio do Incidente:<br>
                            <p type="date" id="inicio-incidente">
                                <%= inicioIncidente != null && !inicioIncidente.trim().isEmpty() ? inicioIncidente : "N�o encontrado" %>
                            </p>
                        </h3>
                    </div>
                    <div class="linha-2-relatorio">
                        <h3 class="setor">Setor:<br>
                            <p><%= setor != null && !setor.trim().isEmpty() ? setor : "N�o encontrado" %></p>
                        </h3>
                        <h3 class="urgencia">Urg�ncia:<br>
                            <p><%= urgencia != null && !urgencia.trim().isEmpty() ? urgencia : "N�o encontrado" %></p>
                        </h3>
                    </div>
                    <div class="botoes">
                        <button id="editar" type="button" onclick="window.location.href='editarRelatorioErro.jsp?id=<%= id %>';">Editar</button>
                        <button id="excluir" type="button" onclick="confirmarExclusao()">Excluir</button> <!-- Alterado -->
                        <button id="adicionar-conclusao" type="button" onclick="window.location.href='adicionarConclusao.jsp?id=<%= id %>';">Adicionar conclus�o</button>
                        
                    </div>
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="excluir" value="true">
                </form>
            </div>
        </div>
    </main>
    <footer></footer>
</body>
</html>
