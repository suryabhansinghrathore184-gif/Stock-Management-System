<%@ Page Title="My Notifications" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_notifications.aspx.cs" Inherits="StockMangementSystem.c_notifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .notification-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
        }
        .notif-item {
            padding: 16px;
            border-bottom: 1px solid #f1f5f9;
            transition: background-color 0.2s ease;
        }
        .notif-item:last-child {
            border-bottom: none;
        }
        .notif-unread {
            background-color: #f0f9ff;
            border-left: 4px solid var(--primary-color);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4 d-flex align-items-center justify-content-between">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Notifications</h3>
                <p class="text-muted small">Stay updated on your orders, system changes, and status alerts</p>
            </div>
            <div>
                <asp:Button ID="BtnMarkAllRead" runat="server" CssClass="btn btn-sm btn-outline-primary me-2" Text="Mark All Read" OnClick="BtnMarkAllRead_Click" />
                <asp:Button ID="BtnClearAll" runat="server" CssClass="btn btn-sm btn-outline-danger" Text="Clear All" OnClick="BtnClearAll_Click" />
            </div>
        </div>

        <!-- Notifications Container -->
        <div class="card notification-card">
            <div class="card-body p-0">
                <asp:Repeater ID="RpNotifications" runat="server" OnItemCommand="RpNotifications_ItemCommand">
                    <ItemTemplate>
                        <div class='notif-item <%# Convert.ToBoolean(Eval("IsRead")) ? "" : "notif-unread" %> d-flex justify-content-between align-items-start'>
                            <div class="d-flex gap-3">
                                <div class="mt-1">
                                    <i class="fa-solid fa-bell text-primary fs-5"></i>
                                </div>
                                <div>
                                    <h6 class="fw-bold text-dark mb-1"><%# Eval("Title") %></h6>
                                    <p class="text-muted small mb-1"><%# Eval("Message") %></p>
                                    <span class="text-black-50" style="font-size: 0.75rem;"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("dd-MM-yyyy HH:mm") %></span>
                                </div>
                            </div>
                            <div>
                                <asp:LinkButton ID="LnkMarkRead" runat="server" CommandName="MarkRead" CommandArgument='<%# Eval("Id") %>' 
                                    Visible='<%# !Convert.ToBoolean(Eval("IsRead")) %>' CssClass="btn btn-sm btn-link text-primary p-0">
                                    Mark as read
                                </asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <%# RpNotifications.Items.Count == 0 ? "<div class='text-center py-5 text-muted'><i class='fa-solid fa-bell-slash fs-2 mb-2 d-block text-secondary'></i>No notifications found.</div>" : "" %>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</asp:Content>
