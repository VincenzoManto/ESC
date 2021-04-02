function featuresRanked = sortRank(features,rankList, numberFeatures)
% This function sorts the number of Features selected
%
%   featuresRanked = sortRank(features,rankList, numberFeatures)
%
% Input: features:                  [2000x15360 double]
%
%        rankList:                  [1x15360 double]
%
%        numberFeatures:            [1x1 double]
%
% Output: featuresRanked:           [2000x_numberFeatures double]
%
%

sortedList = sort(rankList(1:numberFeatures));
featuresRanked = features(:,sortedList);

end