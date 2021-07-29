key = fileread('api-key.txt');
url = 'https://api.solcast.com.au/rooftop_sites/c1dd-f1ba-986d-dee5/forecasts?format=csv&api_key=';
data = webread(join([url, key]));
data = [data; data(end,:); data(end,:)];
writetable(data,'data3.csv');