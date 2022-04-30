<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8">
    <title>Charts</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/ECharts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function (){
            getCharts();
        })

        function getCharts(){
            $.ajax({
                url:"workbench/transaction/getActivityCharts.do",
                type:"post",
                dataType:"json",
                success:function (data){

                    var myChart = echarts.init(document.getElementById('main'));
                    // Initialise the dom
                    // necessary parameters for charts
                    var option = {
                        title: {
                            text: 'Activity Chart',
                            textStyle:{
                                fontSize: 20,
                                fontFamily:'Arial'
                            },
                            x:'left'
                        },
                        tooltip:{
                          trigger:'item',
                          formatter:"{a} <br/>{b} : {c}"
                        },
                        toolbox:{
                            feature:{
                                dataView:{readOnly:false,title:'Data view'},
                                restore:{title:'Restore'},
                                saveAsImage:{title:'Download'},
                            },
                            right:230
                        },
                        legend: {
                            x: 'left',
                            y:30,
                            data: data
                        },
                        series: [
                            {
                                name: 'Activity Chart',
                                type: 'funnel',
                                left: '0%',
                                top: 60,
                                bottom: 60,
                                width: '60%',
                                min: 0,
                                max: data.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 2,
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data
                            }
                        ]
                    };

                    // give the parameters to the charts
                    myChart.setOption(option);
                }
            })
        }
    </script>
</head>
<body>
    <!-- give the echarts a dom container -->
    <div id="main" style="width: 600px;height:400px; position: relative; left: 350px; top: 160px"></div>
<script>




</script>
</body>
</html>
