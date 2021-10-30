BARRIER = 120;
detour_map = BARRIER*ones(13);
p1Block = [5,7];
p2Block = [7,7];
xy = load('alvernhe_coords.txt');
for i=1:size(xy,1)
    detour_map(xy(i,1),xy(i,2))=1;
end
% imagesc(detour_map)

% Each neuron connects to its 4 or 8 neighbors
W_INIT = 5;
Ne1 = size(detour_map,1);
Ne2 = size(detour_map,2);
wgt = zeros(Ne1,Ne2,Ne1,Ne2);
for i = 1:size(wgt,1)
    for j = 1:size(wgt,2)
        for m = -1:1
            for n = -1:1
                if (m == 0 || n == 0) && m ~= n && i+m > 0 && i+m <= size(wgt,2) && j+n > 0 && j+n <= size(wgt,3)
                    wgt(i,j,i+m,j+n) = W_INIT;
                end
            end
        end
    end
end

trainingLoops = 20;
timeConstant = 25;
start = [12 7];
finish = [2 7];
errTraining = zeros(1,trainingLoops);
for i = 1:trainingLoops
    if i == 1 || i == trainingLoops
        % figure;
        [p,wgt,et, l] = spikeWaveEprop (detour_map, wgt, start(1), start(2), finish(1), finish(2), timeConstant, 0);
    else
        [p,wgt,et, l] = spikeWaveEprop (detour_map, wgt, start(1), start(2), finish(1), finish(2), timeConstant, 0);
    end
    pEprop = getPath(p);
    for j=1:size(pEprop,1)
        if detour_map(pEprop(j,1),pEprop(j,2)) == BARRIER
            errTraining(i) = errTraining(i) + 1;
        end
    end
end

wgtTrain = wgt;
mapTrain = detour_map;
testingLoops = 20;
detour_map(p1Block(1),p1Block(2)) = BARRIER;
errDetourP1 = zeros(1,testingLoops/4);
inx = 0;
for i = 1:testingLoops
    if mod(i,5) == 0 % i == 1 || i == testingLoops
        figure;
        [p,wgt,et, l] = spikeWaveEprop (detour_map, wgt, start(1), start(2), finish(1), finish(2), timeConstant, 1);
    else
        [p,wgt,et, l] = spikeWaveEprop (detour_map, wgt, start(1), start(2), finish(1), finish(2), timeConstant, 0);
    end
    pEprop = getPath(p);
    if mod(i,4) == 1
        inx = inx + 1;
    end
    for j=1:size(pEprop,1)
        if detour_map(pEprop(j,1),pEprop(j,2)) == BARRIER
            errDetourP1(inx) = errDetourP1(inx) + 1;
        end
    end
end

wgt=wgtTrain;
detour_map=mapTrain;
detour_map(p2Block(1),p2Block(2)) = BARRIER;
errDetourP2 = zeros(1,testingLoops/4);
inx = 0;
for i = 1:testingLoops
    if mod(i,5) == 0 % i == 1 || i == testingLoops
        figure;
        [p,wgt,et, l] = spikeWaveEprop (detour_map, wgt, start(1), start(2), finish(1), finish(2), timeConstant, 1);
    else
        [p,wgt,et, l] = spikeWaveEprop (detour_map, wgt, start(1), start(2), finish(1), finish(2), timeConstant, 0);
    end
    pEprop = getPath(p);
    if mod(i,4) == 1
        inx = inx + 1;
    end
    for j=1:size(pEprop,1)       
        if detour_map(pEprop(j,1),pEprop(j,2)) == BARRIER
            errDetourP2(inx) = errDetourP2(inx) + 1;
        end
    end
end

% plot(errDetourP1, 'b.--','LineWidth', 2, 'MarkerSize', 35)
% hold on
% plot(errDetourP2, 'k+-.','LineWidth', 2, 'MarkerSize', 10)
% legend (['P1'; 'P2'])
% title('Tolman Detour Maze')
% xlabel('Session')
% xticks([1 2 3 4 5])
% %xticklabels({'1','2','x = 10'})
% ylabel('Errors')




