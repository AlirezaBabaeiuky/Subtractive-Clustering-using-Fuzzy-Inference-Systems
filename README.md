# Subtractive-Clustering-using-Fuzzy-Inference-Systems
Another method of clustering is using the ‘subclust’ function and subtractive clustering technique. Subtractive clustering assumes that each datapoint is a potential cluster center. So the algorithm calculates the likelihood that each data point would define a cluster center based on the density of the surrounding data points. Then algorithm chooses the data point with the highest potential for being the first cluster center and removes the all data points near the first cluster center. The vicinity is determined using a parameter named cluster influence range. Then, algorithm m chooses the points with the highest potential for being the next cluster center. This whole procedure is being repeated until the data is within the influence range of a cluster center. Despite the C-Means clustering, the subtractive type yields the number of clusters automatically. The alternative parameter here is the influence range. Mostly, small number of influence range results in smaller cluster sizes and more clusters. Conversely, bigger influence range result in less clusters and less fuzzy rules. This parameter is ranged from 0 to 1. 

![image](https://user-images.githubusercontent.com/61955953/156658222-bff201f9-f6db-4263-9b6f-b83a80742c3b.png)

![image](https://user-images.githubusercontent.com/61955953/156658253-5c95af3e-2cfe-4f37-9193-329a00514e6d.png)

The codes to generate the fuzzy inference system for subtractive clustering is also enclosed. 
