<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path;
%>
<jsp:include page="diamodsdetail.jsp"></jsp:include>
<jsp:include page="result.jsp"></jsp:include>
<section class="content table-content">
	<form class="form-inline" >
	<!-- 工具栏 -->
	<div id="toolbar">
			<input type="button" value="Submit" id="submitBtn" data-toggle="modal" data-target="#submitModal" class="btn btn-primary" onclick="submit()"></input>
	</div>
	<!-- bootstrapTable -->
	</form>
	<div class="row" style="margin: 10px;">
		 <div class="col-md-12">
		   <table id="tableListForContacts"></table>
		 </div>
	</div>
</section>

<!-- 新增篮子的模态框，在修改用户中将获取一行的值放入input中，改变一些参数继续使用 -->
		<div class="modal fade" id="addModal" tabindex="-1" role="dialog">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h3>Confirm PackageInfo</h3>
					</div>
					<div class="modal-body">
						<form id="addForm" action="" method="post" class="form-horizontal required-validate">
							<div class="form-group">
								<label for="gradlab" class="col-sm-2 control-label">Lab:</label>
								<div class="col-sm-7">
									<input type="text" name="gradlab" class="form-control" id="gradlab" placeholder="" data-bv-notempty readonly="readonly"/>
								</div>
								<label id="errorlab" for="gradlab" class="col-sm-3 control-label"></label>
							</div>
							<div class="form-group">
								<label for="inputBasketNo" class="col-sm-2 control-label">Package Code:</label>
								<div class="col-sm-7">
									<input type="text" name="basketno" class="form-control" id="basketno" placeholder="Package Code" data-bv-notempty readonly="readonly"/>
								</div>
								<label id="errorBasketNo" for="basketno" class="col-sm-3 control-label"></label>
							</div>
							<div class="form-group">
								<label for="result" class="col-sm-2 control-label">Result:</label>
								<div class="col-sm-7">
									<select id="result" class="form-control" name="result">
								      <option value="gia-verified">gia-verified</option>
								      <option value="gia-failure">gia-failure</option>
								      </select>
								</div>
								<label id="errorresult" for="result" class="col-sm-3 control-label"></label>
							</div>
							<div class="form-group">
								<label for="reverification" class="col-sm-2 control-label">Re-verfication ID:</label>
								<div class="col-sm-7">
									<input type="text" name="reverification" class="form-control" id="reverification" placeholder="Re-verfication ID" data-bv-notempty/>
								</div>
								<label id="errorreverification" for="reverification" class="col-sm-3 control-label"></label>
							</div>
							<div class="form-group">
								<label for="giaapproveddate" class="col-sm-2 control-label">Approved Date:</label>
								<div class="col-sm-7">
									<input type="text" name="giaapproveddate" class="form-control" id="giaapproveddate" placeholder="Approved Date" data-bv-notempty/>
								</div>
								<label id="errorrgiaapproveddate" for="giaapproveddate" class="col-sm-3 control-label"></label>
							</div>
							
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" id="conf" class="btn btn-default" onclick="add()">add</button>
						<button type="button" class="btn btn-default" data-dismiss="modal" onclick="resetAddModal()">cancel</button>
					</div>
				</div>				
			</div>
		</div>
			
<script type="text/javascript">
    $(function(){
       var oTable = TableInit();
       oTable.Init();
       
       $("form.required-validate").each(function() {
           var $form = $(this);
           $form.bootstrapValidator();

           // 修复bootstrap validator重复向服务端提交bug
           $form.on('success.form.bv', function(e) {
               // Prevent form submission
               e.preventDefault();
           });


       });
    });
    
    laydate.render({
 	   elem: '#giaapproveddate',
      });
 
    function TableInit() {
        var oTableInit = new Object();
        //初始化Table
        oTableInit.Init = function() {
            $('#tableListForContacts').bootstrapTable({
                url: "<%=basePath %>/confirm/getBasketList",
                pagination: true, //分页
                search: true, //显示搜索框
                //sortable: false,    //是否启用排序
                //sortName: "basketno",
                //sortOrder: "asc",     //排序方式 
                sidePagination: "client", //服务端处理分页server
                pageNumber: 1,                       //初始化加载第一页，默认第一页
                pageSize: 5,                       //每页的记录行数（*）
                pageList: [5,10, 25],//每页的记录行数（*）
                //contentType : "application/x-www-form-urlencoded",
                queryParams: queryParams, //传递参数（*）
                toolbar:"#toolbar",//工具栏
                showColumns: true,                  //是否显示所有的列
                showRefresh: true,                  //是否显示刷新按钮
                responseHandler: function(data){
                    return data.rows;
                },
                columns: [
                    {
                        title: 'number',//标题  可不加
                        width:'64px',
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index) {
                            return index+1;
                        }
                    },
                    {
                        title: 'Package Code',
                        field: 'basketno',
                        align: 'center',
                        valign: 'middle',
                        events: operateEventspackageno,
                        formatter : operateFormatpackageno,
                    },
                    {
                        title: 'Result',
                        field: 'result',
                        align: 'center',
                        valign: 'middle',
                    },{
                        title: 'Approved Date',
                        field: 'giaapproveddate',
                        align: 'center',
                        valign: 'middle',
                    },{
                        title: 'Lab',
                        field: 'gradlab',
                        align: 'center',
                        valign: 'middle',
                        visible: false,
                    },{
                        title: 'operation',
                        field: 'status',
                        align: 'center',
                        valign: 'middle',
                        events: operateEvents,
                        formatter : operateFormat,
                    }
                ]
            });
        };
        return oTableInit;
    };
 
    
    //binding event shuhao.song
    window.operateEvents = {
		'click #addBtn': function(e, value, row, index) {
			resetAddModal();
			$("#basketno").val(row.basketno);
			$("#gradlab").val(row.gradlab);
   		}
   	};
    
    function operateFormat(value, row, index) {
   	 var status = value;
   	 if(status=='6'){
   		 return '';
   	 }else if(status=='5'){
   		 return '<input type="button" value="Add" id="addBtn" data-toggle="modal" data-target="#addModal" class="btn btn-primary"></input>';
   	}
    }
    
    var step = "gta";
    function queryParams(params) {
    	return {
    		limit : this.limit, // 页面大小
	        offset : this.offset, // 页码
	        pageNumber : this.pageNumber,
	        pageSize : this.pageSize,
	        step:step
    	};
    };
    
    function search() {
    	$('#tableListForContacts').bootstrapTable('refresh');
    }
    
    function submit()
    {
    	
    	var index = layer.load(1);
    	var url = "<%=basePath %>/confirm/submitBasketList";
    	var param = {"step":step};
    	$.ajax({
			url:url,
			method:"post",
			data:param,
			dataType:"json",
			success:function(data){
				layer.close(index);
				if(data.state=="success"){
					messageShow(data,null,true)
				}
				if(data.state=="fail"){
					messageShow(data,null,true)
				}
			},
			error:function(){
				layer.close(index);
				messageShow(null,null,true)
			}
		});
    }
    
  //点击取消后清空表单中已写信息
	function resetAddModal(){
		document.getElementById("addForm").reset();
	}
	//Modal验证销毁重构
    $('#addModal').on('hidden.bs.modal', function() {
        $("#addForm").data('bootstrapValidator').destroy();
        $('#addForm').data('bootstrapValidator', null);
        $('#addForm').bootstrapValidator();
    });
	
	//新增用户
	function add(){
		
		var $form = $("#addForm");

        var data = $form.data('bootstrapValidator');
        if (data) {
        // 修复记忆的组件不验证
            data.validate();

            if (!data.isValid()) {
                return false;
            }
        }
		
        var index = layer.load(1);
		var param = $("#addForm").serializeArray();
		param.push({"name":"step","value":step});
		$("#conf").attr("onclick","add()");
		$.ajax({
			url:"<%=basePath %>/confirm/updateBasketInfo",
			method:"post",
			data:param,
			dataType:"json",
			success:function(data){
				layer.close(index);
				if(data.state=="success"){
					messageShow(data,"#addModal",false)
				}
				if(data.state=="fail"){
					messageShow(data,"#addModal",false)
				}
			},
			error:function(){
				layer.close(index);
				messageShow(null,"#addModal",false)
			}
		});
	}

</script>
