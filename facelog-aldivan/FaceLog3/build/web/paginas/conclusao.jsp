<%@ page import="java.sql.*" %>
<%
    // Recuperar o ID do relat�rio passado pela URL
    String idParam = request.getParameter("id");
    int id = 0;
    
    // Verifica se o ID foi fornecido na URL
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
    String titulo = "", descricaoErro = "", descricaoResolucao = "", inicioIncidente = "", fimIncidente = "", setor = "", urgencia = "";

    // Conex�o com o banco de dados
    String dbUrl = "jdbc:mysql://localhost:3306/facelog";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // Recuperar os dados do relat�rio conclu�do com base no ID
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        String sql = "SELECT * FROM concluidos WHERE id_relatorio = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, id);
        rs = stmt.executeQuery();

        if (rs.next()) {
            titulo = rs.getString("titulo");
            descricaoErro = rs.getString("decricao_erro");
            descricaoResolucao = rs.getString("decricao_resolucao");
            inicioIncidente = rs.getString("inicio_incidente");
            fimIncidente = rs.getString("fim_incidente");
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
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relat�rio Conclu�do</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/container.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/menu.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/conclusao/conclusao.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global/footer.css">
</head>
<body>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/icones/facebook.svg" alt="icone do facebook"id="logo-img">
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
                <label for="pendentes" class="menu-toggle">Pendentes
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
                <h2 class="nome-menu">Relat�rio Conclu�do<hr class="blue-line"></h2>
                <form>
                    <div class="div-status">
                        <h3 class="titulo">T�tulo:<br><p id="titulo"><%= titulo != null && !titulo.trim().isEmpty() ? titulo : "N�o encontrado" %></p></h3>
                    </div>
                    <h3 class="descricao">Descri��o do Erro:<br><br><p id="descricao"><%= descricaoErro != null && !descricaoErro.trim().isEmpty() ? descricaoErro : "N�o encontrado" %></p></h3>
                    <br>
                    <h3 class="descricao-resolucao">Descri��o da resolu��o do erro:<br><br><p id="resolucao-erro"><%= descricaoResolucao != null && !descricaoResolucao.trim().isEmpty() ? descricaoResolucao : "N�o encontrado" %></p></h3>
                    <br>
                    <div class="linha-1-relatorio">
                        <h3 class="codigo">C�digo de Identifica��o:<p id="codigo"><%= id %></p><h3>
                        <h3 class="inicio-incidente">In�cio do Incidente:<br><p id="inicio-incidente"><%= inicioIncidente != null && !inicioIncidente.trim().isEmpty() ? inicioIncidente : "N�o encontrado" %></p></h3>
                        <h3 class="fim-incidente">Fim do Incidente:<br><p id="fim-incidente"><%= fimIncidente != null && !fimIncidente.trim().isEmpty() ? fimIncidente : "N�o encontrado" %></p></h3>
                    </div>
                    <div class="linha-2-relatorio">
                        <h3 class="setor">Setor:<br><p><%= setor != null && !setor.trim().isEmpty() ? setor : "N�o encontrado" %></p></h3>
                        <h3 class="urgencia">Urg�ncia:<br><p><%= urgencia != null && !urgencia.trim().isEmpty() ? urgencia : "N�o encontrado" %></p></h3>
                    </div>
                    <div class="botoes">
                        <button id="concluir" type="submit">Excluir</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    <footer></footer>
</body>
</html>