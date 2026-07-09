<%@ Page Title="" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_logout.aspx.cs" Inherits="StockMangementSystem.WebForm17" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
    .auto-style1 {
        width: 100%;
        height: 107px;
    }
    .auto-style2 {
        text-align: center;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table class="auto-style1">
    <tr>
        <td class="auto-style2">You Have Logout Successfully</td>
    </tr>
    <tr>
        <td class="auto-style2">
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="logout" />
        </td>
    </tr>
</table>
</asp:Content>
