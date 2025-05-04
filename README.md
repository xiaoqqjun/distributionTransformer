## 简介

distributionTransformer 是一个用于分析变量分布并提供转换建议的 R 包。该包可以帮助数据科学家和统计学家为需要正态分布假设的统计分析准备数据。

## 功能特点

- 📊 **分布分析**：评估偏度、峰度和正态性检验
- 🔄 **转换建议**：自动提供数据转换建议
- 📈 **可视化工具**：比较原始和转换后的分布
- 📝 **综合报告**：生成详细的分析报告
- 🗂️ **批量处理**：同时分析多个变量

## 安装方法

您可以从 GitHub 安装开发版本：

```r
# install.packages("devtools")
devtools::install_github("yourusername/distributionTransformer")
```

## 基本用法

```r
library(distributionTransformer)

# 创建示例数据
data <- data.frame(
  normal = rnorm(100),
  right_skewed = rexp(100),
  left_skewed = rbeta(100, 5, 1)
)

# 分析单个变量
result <- evaluate_distribution(data$right_skewed, "right_skewed")
print(result$recommendation)

# 生成综合报告
generate_transformation_report(data, names(data))

# 可视化转换效果
visualize_transformation_effects(data, "right_skewed")

# 创建汇总表
summary <- create_transformation_summary(data, names(data))
```

## 主要函数

- `evaluate_distribution()`: 评估单个变量的分布特征
- `generate_transformation_report()`: 生成详细的转换建议报告
- `visualize_transformation_effects()`: 可视化转换前后的分布比较
- `create_transformation_summary()`: 创建多变量的汇总表格

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE.md](LICENSE.md) 文件

## 作者

* **Zhijun Feng** - [GitHub](https://github.com/xiaoqqjun)

## 致谢

感谢所有为本项目做出贡献的人员。
