# ML4SocialScience
These are the class notes for my course on machine learning for social science (CRIM6012/SOCI6012) that I have taught at the University of Pennsylvania since 2024. The course aims to 
-  build foundational skills essential for machine learning (calculus, linear algebra, probability)
-  cover a range of machine learning methods, primarily supervised learning methods
-  show applications on a range of social science problems
   -  predicting recidivism risk
   -  predicting high school dropout (NELS88)
   -  exploring media censorship (Varieties of Democracy, V-Dem)
   -  studying links between arrest and opiod use (NSDUH)
   -  measure racial disparities in pedestrian stop outcomes
   -  text analysis of officer-involved shooting incident reports
   -  building a *small* language model based only on *Crime and Punishment*

These notes are best viewed at the [ML4SocialScience github.io site](https://gregridgeway.github.io/ML4SocialScience).

Table of contents
1. [Probability review](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L01-probability-review.html)
2. [Naïve Bayes classifier](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L02-naive-Bayes.html)
3. [Prediction, bias, variance, and noise](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L03-prediction-bias-variance.html)
    -   k-nearest neighbor regression and classification
    -   Example: Predict dropout risk from the NELS88 data
    -   Spam example
4. [Differential calculus review](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L04-calculus-review.html)
5. [Classification and regression trees](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L05-trees.html)
6. [Linear algebra](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L06-linear-algebra.html)
    -   Basic matrix operations, including matrix derivatives
    -   Ordinary least squares and ridge regression
    -   Multivariate Taylor series, Newton-Raphson, logistic regression, iteratively reweighted least squares (IRLS)
7. [Singular value decomposition](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L07-svd.html)
    -   Image compression
    -   Image classification with emojis
8. [Boosting and L1 regularization](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L08-boosting.html)
    - Lasso
    - Forward stagewise selection
    - Gradient boosting
9. [Propensity score estimation](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L09-propensity-score-estimation.html)
    - Simpson's paradox and confounders
    - Neyman-Rubin causal model
    - Propensity score weighting
       - using machine learning to estimate propensity scores
       - `fastDR` package
10. [Neural networks](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L10-neural-nets.html)
    - Backpropagation "by hand"
    - `neuralnet` package
    - `Tensorflow` and `Keras`
    - Convolutional layers
    - MNIST postal digits dataset
11. [Text analysis](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L11-text.html)
    - Working with `text2vec`
    - DTM and TFIDF
    - SVD for text
12. [Long short-term memory (LSTM) neural networks](https://raw.githack.com/gregridgeway/ML4SocialScience/main/L12-RNN.html)
    - LSTM models
    - a *small* language model
