<%@ Page Title="Customer Support" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_support.aspx.cs" Inherits="StockMangementSystem.c_support" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .support-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
        .chat-box {
            max-height: 300px;
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
            max-width: 80%;
            font-size: 0.9rem;
        }
        .chat-user {
            background-color: var(--primary-color);
            color: #fff;
            margin-left: auto;
            border-bottom-right-radius: 2px;
        }
        .chat-agent {
            background-color: #e2e8f0;
            color: #1e293b;
            margin-right: auto;
            border-bottom-left-radius: 2px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Customer Support Center</h3>
            <p class="text-muted small">Submit billing/technical tickets and read FAQs</p>
        </div>

        <div class="row">
            <!-- Left Side: FAQs -->
            <div class="col-lg-5 mb-4">
                <div class="card support-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-circle-question text-primary me-2"></i>Frequently Asked Questions</h5>
                    <div class="accordion" id="faqAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                                    How do I place an order?
                                </button>
                            </h2>
                            <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                                <div class="accordion-body text-muted small">
                                    You can place a simulated purchase by adding products to your Wishlist first, then clicking the "Buy Now" button.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                                    Where can I download my invoice?
                                </button>
                            </h2>
                            <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body text-muted small">
                                    Go to the "Order History" tab in the sidebar, locate your invoice, and click the "Print/PDF" action button.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree">
                                    How do I update my billing addresses?
                                </button>
                            </h2>
                            <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body text-muted small">
                                    Go to the "Address Book" tab in the sidebar to add, edit, or delete multiple delivery locations.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Ticketing -->
            <div class="col-lg-7 mb-4">
                <!-- Submit a ticket card -->
                <div class="card support-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-paper-plane text-success me-2"></i>Create Support Ticket</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Subject / Issue Title</label>
                            <asp:TextBox ID="TxtSubject" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Category</label>
                            <asp:DropDownList ID="DdlCategory" runat="server" CssClass="form-select form-select-sm">
                                <asp:ListItem Text="Billing & Invoice" Value="Billing"></asp:ListItem>
                                <asp:ListItem Text="Technical Support" Value="Technical"></asp:ListItem>
                                <asp:ListItem Text="Product Inquiries" Value="Inquiries"></asp:ListItem>
                                <asp:ListItem Text="Other Issues" Value="Other"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Detail Description</label>
                        <asp:TextBox ID="TxtDesc" runat="server" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                    <asp:Button ID="BtnSubmitTicket" runat="server" Text="Submit Ticket" CssClass="btn btn-sm btn-primary" OnClick="BtnSubmitTicket_Click" />
                </div>

                <!-- Active Tickets -->
                <div class="card support-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-list-check text-warning me-2"></i>My Support Tickets</h5>
                    <div class="table-responsive">
                        <asp:GridView ID="GvTickets" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None"
                            DataKeyNames="TicketId" OnSelectedIndexChanged="GvTickets_SelectedIndexChanged">
                            <Columns>
                                <asp:BoundField DataField="TicketId" HeaderText="ID" />
                                <asp:BoundField DataField="Subject" HeaderText="Subject" />
                                <asp:BoundField DataField="Category" HeaderText="Category" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# Eval("Status").ToString() == "Resolved" ? "bg-success" : (Eval("Status").ToString() == "Pending" ? "bg-warning" : "bg-primary") %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ShowSelectButton="True" SelectText="Open Chat" ControlStyle-CssClass="btn btn-xs btn-outline-info" />
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-3 text-muted">
                                    You have not submitted any tickets.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Chat Pane (Visible only when ticket selected) -->
                <asp:Panel ID="PanelChat" runat="server" CssClass="card support-card p-4" Visible="false">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-comments text-info me-2"></i>Ticket Discussion (ID: <asp:Label ID="LblSelectedTicketId" runat="server"></asp:Label>)</h5>
                    <div class="chat-box mb-3" id="chatBox">
                        <asp:Repeater ID="RpReplies" runat="server">
                            <ItemTemplate>
                                <div class='chat-bubble <%# Eval("SenderId").ToString() == Session["cid"].ToString() ? "chat-user" : "chat-agent" %>'>
                                    <div class="fw-bold" style="font-size: 0.75rem;"><%# Eval("SenderId").ToString() == Session["cid"].ToString() ? "You" : "Support Agent" %></div>
                                    <div><%# Eval("Message") %></div>
                                    <div class="text-black-50 text-end" style="font-size: 0.65rem;"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("dd-MM HH:mm") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="input-group">
                        <asp:TextBox ID="TxtReply" runat="server" CssClass="form-control" Placeholder="Type a message..."></asp:TextBox>
                        <asp:Button ID="BtnSendReply" runat="server" CssClass="btn btn-primary" Text="Send" OnClick="BtnSendReply_Click" />
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
