<%@ Page Title="Business Documents" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_documents.aspx.cs" Inherits="StockMangementSystem.s_documents" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .doc-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Business Documents</h3>
            <p class="text-muted small">Upload and verify your registration certificates, licenses, and PAN documents</p>
        </div>

        <div class="row">
            <!-- Left Side: Upload Form -->
            <div class="col-lg-5 mb-4">
                <div class="card doc-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i>Upload New Document</h5>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Document Category</label>
                        <asp:DropDownList ID="DdlDocType" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="GST Registration Certificate" Value="GST Certificate"></asp:ListItem>
                            <asp:ListItem Text="PAN Card" Value="PAN Card"></asp:ListItem>
                            <asp:ListItem Text="Business Trade License" Value="Business License"></asp:ListItem>
                            <asp:ListItem Text="Bank Canceled Cheque" Value="Bank Verification"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Select File (PDF, PNG, JPG - Max 5MB)</label>
                        <asp:FileUpload ID="FuDoc" runat="server" CssClass="form-control form-control-sm" />
                    </div>
                    <asp:Button ID="BtnUpload" runat="server" Text="Upload Document" CssClass="btn btn-sm btn-primary" OnClick="BtnUpload_Click" />
                </div>
            </div>

            <!-- Right Side: Uploaded Documents List -->
            <div class="col-lg-7 mb-4">
                <div class="card doc-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-folder-open text-success me-2"></i>Uploaded Documents</h5>
                    <div class="table-responsive">
                        <asp:GridView ID="GvDocs" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None"
                            DataKeyNames="DocId" OnRowCommand="GvDocs_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="DocumentType" HeaderText="Document Type" />
                                <asp:TemplateField HeaderText="Uploaded Date">
                                    <ItemTemplate>
                                        <%# Convert.ToDateTime(Eval("UploadedDate")).ToString("dd-MM-yyyy HH:mm") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <a href='<%# "/Links/" + Eval("FilePath") %>' target="_blank" class="btn btn-xs btn-outline-primary me-1">
                                            <i class="fa-solid fa-download"></i> View / Download
                                        </a>
                                        <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteDoc" CommandArgument='<%# Eval("DocId") %>' CssClass="btn btn-xs btn-outline-danger">
                                            <i class="fa-solid fa-trash"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-4 text-muted">
                                    No documents uploaded yet.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
