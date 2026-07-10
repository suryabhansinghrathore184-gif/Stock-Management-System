<%@ Page Title="Support Tickets Helpdesk" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="admin_tickets.aspx.cs" Inherits="StockMangementSystem.admin_tickets" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .ticket-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
        .chat-box {
            max-height: 320px;
            overflow-y: auto;
            background: #f8fafc;
            border-radius: 8px;
            padding: 15px;
            border: 1px solid #e2e8f0;
        }
        .chat-bubble {
            padding: 10px 14px;
            border-radius: 12px;
            margin-bottom: 10px;
            max-width: 85%;
            font-size: 0.9rem;
        }
        .chat-admin {
            background-color: var(--primary-color);
            color: #fff;
            margin-left: auto;
            border-bottom-right-radius: 2px;
        }
        .chat-user {
            background-color: #e2e8f0;
            color: #1e293b;
            margin-right: auto;
            border-bottom-left-radius: 2px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Support Tickets Helpdesk</h3>
            <p class="text-muted small">Manage billing and technical tickets submitted by customers and suppliers</p>
        </div>

        <div class="row">
            <!-- Left Side: Tickets Registry -->
            <div class="col-lg-7 mb-4">
                <div class="card ticket-card p-4">
                    <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-list-check text-primary me-2"></i>Active Tickets</h5>
                        <div>
                            <asp:DropDownList ID="DdlFilterStatus" runat="server" CssClass="form-select form-select-sm d-inline-block w-auto" AutoPostBack="true" OnSelectedIndexChanged="DdlFilterStatus_SelectedIndexChanged">
                                <asp:ListItem Text="All Statuses" Value=""></asp:ListItem>
                                <asp:ListItem Text="Open" Value="Open"></asp:ListItem>
                                <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                <asp:ListItem Text="Resolved" Value="Resolved"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <asp:GridView ID="GvTickets" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None"
                            DataKeyNames="TicketId" OnSelectedIndexChanged="GvTickets_SelectedIndexChanged"
                            AllowPaging="True" PageSize="6" OnPageIndexChanging="GvTickets_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="TicketId" HeaderText="ID" />
                                <asp:BoundField DataField="UserId" HeaderText="User ID" />
                                <asp:BoundField DataField="UserRole" HeaderText="Role" />
                                <asp:BoundField DataField="Subject" HeaderText="Subject" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# Eval("Status").ToString() == "Resolved" ? "bg-success" : (Eval("Status").ToString() == "Pending" ? "bg-warning" : "bg-primary") %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ShowSelectButton="True" SelectText="Open Chat" ControlStyle-CssClass="btn btn-xs btn-outline-info" />
                            </Columns>
                            <PagerStyle CssClass="pagination-container" />
                            <EmptyDataTemplate>
                                <div class="text-center py-3 text-muted">
                                    No support tickets found matching the status filter.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- Right Side: Chat & Reply Panel -->
            <div class="col-lg-5 mb-4">
                <asp:Panel ID="PanelChat" runat="server" CssClass="card ticket-card p-4" Visible="false">
                    <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-comments text-success me-2"></i>Discussion Thread</h5>
                        <div>
                            <span class="small text-muted me-1">Status:</span>
                            <asp:DropDownList ID="DdlTicketStatus" runat="server" CssClass="form-select form-select-xs d-inline-block w-auto" AutoPostBack="true" OnSelectedIndexChanged="DdlTicketStatus_SelectedIndexChanged">
                                <asp:ListItem Text="Open" Value="Open"></asp:ListItem>
                                <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                <asp:ListItem Text="Resolved" Value="Resolved"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="mb-3 bg-light p-2.5 rounded text-muted small">
                        <strong>Ticket ID:</strong> <asp:Label ID="LblTicketId" runat="server"></asp:Label><br />
                        <strong>Submitted By:</strong> <asp:Label ID="LblTicketUser" runat="server"></asp:Label> (<asp:Label ID="LblTicketRole" runat="server"></asp:Label>)<br />
                        <strong>Subject:</strong> <asp:Label ID="LblTicketSubject" runat="server"></asp:Label>
                    </div>

                    <div class="chat-box mb-3" id="chatBox">
                        <asp:Repeater ID="RpReplies" runat="server">
                            <ItemTemplate>
                                <div class='chat-bubble <%# Eval("SenderId").ToString() == "Admin" ? "chat-admin" : "chat-user" %>'>
                                    <div class="fw-bold" style="font-size: 0.75rem;"><%# Eval("SenderId").ToString() == "Admin" ? "Admin Staff" : "User (" + Eval("SenderId") + ")" %></div>
                                    <div><%# Eval("Message") %></div>
                                    <div class="text-black-50 text-end" style="font-size: 0.65rem;"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("dd-MM HH:mm") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="input-group">
                        <asp:TextBox ID="TxtReply" runat="server" CssClass="form-control" Placeholder="Type a reply..."></asp:TextBox>
                        <asp:Button ID="BtnSendReply" runat="server" CssClass="btn btn-primary" Text="Send" OnClick="BtnSendReply_Click" />
                    </div>
                </asp:Panel>
                
                <asp:Panel ID="PanelNoTicket" runat="server" CssClass="card ticket-card p-4 text-center py-5 text-muted">
                    <i class="fa-solid fa-comments fs-1 mb-2 text-secondary"></i>
                    <p class="m-0">Select a support ticket from the list to view conversations and post replies.</p>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
