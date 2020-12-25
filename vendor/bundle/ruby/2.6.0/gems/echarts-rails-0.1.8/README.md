# echarts-rails

Wrappers of ECharts Javascript Chart Libary for Rails 3.1+

Check out how to use ECharts at http://echarts.baidu.com

* echarts-rails 0.1.0 -> ECharts 3.1.3
* echarts-rails 0.1.4 -> ECharts 3.2.3
* echarts-rails 0.1.5 -> ECharts 3.3.0
* echarts-rails 0.1.6 -> ECharts 3.3.2
* echarts-rails 0.1.7 -> ECharts 3.7.1
* echarts-rails 0.1.8 -> ECharts 3.7.2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'echarts-rails'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install echarts-rails
```

Now you need to edit your `app/assets/javascripts/application.js` file and add `echarts` , `echarts-simple` or `echarts-common` into it:

```
//= require echarts
```

The difference between `echarts` , `echarts.simple` or `echarts.common` :

* `echarts-en`: Includes all charts and components.
* `echarts.simple-en`: Only includes basic charts: line bar pie.
* `echarts.common-en`: Includes common charts and components: line bar pie scatter legend tooltip toolbox markLine markPoint markArea dataZoom

* `echarts`: 包含所有图表组件。
* `echarts.simple`: 只包含基础图表： 折 柱 饼。
* `echarts.common`: 包含常用的图表组件：折 柱 饼 散点 图例 工具栏 标注 标线 数据区域缩放

And you're done!

## Usage

```
<!-- prepare a DOM container with width and height -->
<div id="main" style="width: 600px;height:400px;"></div>
<script type="text/javascript">
    // based on prepared DOM, initialize echarts instance
    var myChart = echarts.init(document.getElementById('main'));

    // specify chart configuration item and data
    var option = {
        title: {
            text: 'ECharts entry example'
        },
        tooltip: {},
        legend: {
            data:['Sales']
        },
        xAxis: {
            data: ["shirt","cardign","chiffon shirt","pants","heels","socks"]
        },
        yAxis: {},
        series: [{
            name: 'Sales',
            type: 'bar',
            data: [5, 20, 36, 10, 10, 20]
        }]
    };

    // use configuration item and data specified to show chart
    myChart.setOption(option);
</script>
```

You can also go to [ECharts Gallery](https://ecomfe.github.io/echarts-examples/public/editor.html?c=doc-example/getting-started) to view examples.

## License

The gem is available as open source under the BSD license.

[ECharts](https://github.com/ecomfe/echarts/blob/master/LICENSE) is available under the BSD license.

