---
title: 2025-03-18-VitPose 基于 vit 的姿态评估模型
tags: 
    深度学习
    论文阅读
---

> 相关论文
> [ViTPose: Simple Vision Transformer Baselines for Human Pose Estimation](https://arxiv.org/abs/2204.12484)

# Motivation

1. **研究问题**：这篇文章要解决的问题是如何利用简单的 ViT（Vision Transformer）进行人体姿态估计。尽管 ViT 在视觉识别任务中表现出色，但在姿态估计任务中的应用仍然有限。
2. **研究难点**：该问题的研究难点包括：如何在不使用复杂结构设计的情况下实现高性能的姿态估计；如何提高模型的规模可扩展性；如何在训练过程中保持灵活性；以及如何在不同模型之间有效地转移知识。
3. **相关工作**：该问题的研究相关工作有：PRTR、TokenPose、TransPose、HRFormer 等方法，这些方法通常采用 CNN 作为主干网络(传统的网络对于对于局部特征的提取能力很强大,但是全局特征信息提取能不很差)，然后使用复杂的变压器结构来细化特征和建模关键点之间的关系。然而，这些方法要么需要额外的 CNN 进行特征提取，要么需要对变压器结构进行精心设计以适应任务。

# Method

这篇论文提出了一个名为 ViTPose 的简单基线模型，用于解决人体姿态估计问题。具体来说，

1. **模型结构**：ViTPose 采用简单的非分层视觉变压器作为主干网络，用于提取给定人体实例的特征图。主干网络通过预训练的掩码图像建模（Masked Image Modeling, MAE）任务进行初始化。然后，一个轻量级解码器处理提取的特征，通过上采样特征图和回归关键点热图来进行姿态估计。解码器由两个反卷积层和一个预测层组成。

![17423110798271742311079755.png](https://tk-pichost-1325224430.cos.ap-chengdu.myqcloud.com/blog/17423110798271742311079755.png)


1. **可扩展性**：通过堆叠不同数量的变压器层和增加或减少特征维度，可以轻松控制模型大小。例如，可以使用 ViT-B、ViT-L 或 ViT-H 来平衡推理速度和性能。
2. **灵活性**：ViTPose 在训练范式方面非常灵活，可以适应不同的输入分辨率和特征分辨率。通过添加额外的解码器，可以灵活地适应多个姿态数据集，从而实现联合训练管道并显著提高性能。此外，即使在使用较小的未标记数据集进行预训练或冻结注意力模块进行微调时，ViTPose 仍能获得 SOTA 性能。
3. **知识转移**：通过一个额外的可学习知识令牌，可以将大模型的知识转移到小模型中，从而提高小模型的性能。

# Result

1. **结构简单性和可扩展性**：使用简单解码器的 ViTPose 在 MS COCO 验证集上的表现与使用复杂解码器的 ResNet-50 和 ResNet-152 相当，表明普通视觉变压器具有强大的表示能力。随着模型大小的增加，ViTPose 的性能一致提高，展示了其良好的可扩展性。
2. **预训练数据灵活性**：使用 MS COCO 和 AI Challenger 数据组合进行预训练的 ViTPose 在 MS COCO 验证集上的表现与使用 ImageNet-1K 数据预训练的模型相当，表明使用下游任务数据进行预训练具有更好的数据效率。
3. **输入分辨率灵活性**：随着输入分辨率的增加，ViTPose 的性能也相应提高。使用正方形输入尺寸并未带来显著的性能提升，可能是因为 MS COCO 中人体的平均宽高比为 4:3，正方形输入尺寸不符合统计特性。
4. **注意力类型灵活性**：使用全注意力机制的 ViTPose 在 MS COCO 验证集上获得了最佳的 77.4 AP，但存在较大的内存占用。通过使用窗口注意力并结合移位窗口和池化窗口机制，可以在不显著增加内存占用的前提下提高性能。
5. **部分微调灵活性**：在部分微调设置下，冻结 MHSA 模块的 ViTPose 性能仅略有下降，而冻结 FFN 模块则导致显著的性能下降，表明 FFN 模块对任务特定建模更为重要。
6. **多数据集训练**：使用多数据集训练的 ViTPose 在 MS COCO 验证集上的性能从 75.8 AP 提高到 77.1 AP，表明 ViTPose 可以很好地利用不同数据集中的多样性数据。
7. **知识转移**：通过知识令牌蒸馏，ViTPose-B 模型的 AP 提高了 0.2，而输出蒸馏则提高了 0.5，两种蒸馏方法相互补充，共同使用时可达到 76.6 AP，验证了 ViTPose 模型的良好可迁移性。

> [https://yuanbao.tencent.com/bot/app/share/deep-reading-tab/deepRead/4w6dL6ZYki6w](https://yuanbao.tencent.com/bot/app/share/deep-reading-tab/deepRead/4w6dL6ZYki6w)

> [https://yuanbao.tencent.com/bot/app/share/deep-reading-tab/summary/Tzi4OLgzGSzl](https://yuanbao.tencent.com/bot/app/share/deep-reading-tab/summary/Tzi4OLgzGSzl)
