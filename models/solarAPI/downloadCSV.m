data = webread('https://api.solcast.com.au/rooftop_sites/c1dd-f1ba-986d-dee5/forecasts?format=csv&api_key=tiQc74hB1dsEU2LvBVKxxB5LA4lQumVQ');
writetable(data,'data.csv');