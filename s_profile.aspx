<%@ Page Title="" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_profile.aspx.cs" Inherits="StockMangementSystem.WebForm13" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style2 {
            width: 776px;
            text-align: center;
        }
        .auto-style3 {
            width: 776px;
            height: 26px;
            text-align: center;
        }
        .auto-style4 {
            height: 26px;
            text-align: center;
        }
        .auto-style5 {
            text-align: center;
        }
    </style>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table class="auto-style1">
        <tr>
            <td class="auto-style3">Supplier Photo</td>
            <td class="auto-style4">
                <asp:Image ID="Image1" runat="server" Height="102px" />
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Supplier ID</td>
            <td class="auto-style5">
                <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Supplier Name</td>
            <td class="auto-style5">
                <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Company Name</td>
            <td class="auto-style5">
                <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Contact Person</td>
            <td class="auto-style5">
                <asp:Label ID="Label4" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Phone Number</td>
            <td class="auto-style5">
                <asp:Label ID="Label5" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Email ID</td>
            <td class="auto-style5">
                <asp:Label ID="Label6" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Address</td>
            <td class="auto-style5">
                <asp:Label ID="Label7" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style3">City</td>
            <td class="auto-style4">
                <asp:Label ID="Label8" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">GST Number</td>
            <td class="auto-style5">
                <asp:Label ID="Label9" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">Supplier Status</td>
            <td class="auto-style5">
                <asp:Label ID="Label10" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
    </table>
    </asp:Content>
