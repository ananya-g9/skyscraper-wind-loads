% testGEV.m
x = linspace(-3,6,1000);
y1 = gevpdf(x,-.5,1,0); 
y2 = gevpdf(x,0,1,0); 
y3 = gevpdf(x,.5,1,0);
plot(x,y1,'.c', x,y2,'.b', x,y3,'.r')
legend({'alpha < 0, Type III' 'alpha = 0, Type I' 'alpha > 0, Type II'}, 'FontSize', 12)