<%@ Page Title="" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_logout.aspx.cs" Inherits="StockMangementSystem.WebForm14" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <p class="auto-style1">
        You Have Logout SuccessFully</p>
    <p class="auto-style1">
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="logout" />
    </p>
</asp:Content>
