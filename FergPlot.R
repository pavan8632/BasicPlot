library(grid)
library(ggplot2)
library(scales)
#change htis later to a dirname call


LoadingSort<-function(df,cutoff,numarr){
  #Creating a list of sorted variables by PC, then choosing top (numArr) ones to display)
  data<-df[order(-abs(df[,1])), ,drop=FALSE]
  data.head<-head(data,numarr)
  #INITIALIZING A COUNTER
  count<-0
  for(i in 1:nrow(data.head)){
    if(abs(data.head[i,1])>cutoff){
      count=count+1
    }
  }
  #Returns a dataframe that has a max of the highest  loading scores (+/-) above a cutoff, 
  data.head<-head(data.head,count)
  return(data.head)
}



#Run LoadingSort First before running FergusonPlot
#df is a sorted single column of loading,
FergusonPlotCoordinates<-function(df){
  div<-2*pi/(nrow(df))
  x1<-vector()
  x2<-vector()
  y1<-vector()
  y2<-vector()
  txtangle<-vector()
  val<-vector()
  center<-vector()
  angle<-vector()
  row<-vector()
  pc<-vector()
  xmid<-vector()
  ymid<-vector()
  for(i in 1:nrow(df)){
    disp<-div*i
    angle<-c(angle,as.numeric(disp))
    
    xstart<-10*cos(disp)
    xend<-3*cos(disp)
    xm<-(xstart+xend)/2
    x1<-c(x1,as.numeric(xstart))
    x2<-c(x2,as.numeric(xend))
    xmid<-c(xmid,as.numeric(xm))
    
    ystart<-10*sin(disp)
    yend<-3*sin(disp)
    ym<-(ystart+yend)/2
    y1<-c(y1,as.numeric(ystart))
    y2<-c(y2,as.numeric(yend))
    ymid<-c(ymid,as.numeric(ym))
    
    row<-c(row,rownames(df)[i])
    
    
    if((disp>pi/2)&(disp<=pi))
      tang<-(disp-pi)
    else if((disp>pi)&(disp<=3*pi/2))
    {
      tang<--(pi-disp)
      
    }else
    {  tang<-disp
       
    }
    txtangle<-c(txtangle,as.numeric(tang))
    
    value<-c(df[i,1])
    val<-c(val,(round(as.numeric(value),digits=3)))
    
    
    center<-c(center,as.numeric(0))
    
    lab<-colnames(df)
    pc<-c(pc,lab)
  }
  arr.dat<-data.frame(row,x1,y1,x2,y2,xmid,ymid,val,center,angle,pc,txtangle,stringAsFactors=1)
  return(arr.dat)
}

#Takes a Loading from FergusonCoord, and the variance explained by this pc
FergusonPlot1<-function(arr.dat,var.explained){
  b<-c(-1,0,1)
  var.explained<-round(var.explained,digits=3)
  img<-readPNG("./PCVenn.png")
  g<-rasterGrob(img,interpolate=TRUE)
  plot.grid<-ggplot(data=arr.dat,aes(colour=val,size=val))+
    scale_colour_gradient2(limits=c(-1,1),low="blue",mid="black",high="red",midpoint=0,guide='colourbar',breaks=b,labels=format(b))+
    scale_size(limits=c(0,8),guide=FALSE)+
    theme_bw()#+coord_fixed()# +facet_grid(pc ~.)
  plot.grid<-plot.grid+
    scale_x_continuous(name="",limits=c(-13,13))+
    scale_y_continuous(name="",limits=c(-13,13))+
    geom_segment(data=arr.dat, aes(x=x1,y=y1,xend=x2,yend=y2,size=abs(val)*8),arrow=arrow(type='closed',length=unit(abs(arr.dat$val)/4+.1,"in")))+
    geom_text(data=arr.dat,aes(x=center+11.5*cos(angle), y=center+11*sin(angle),label=row),colour="black",size=4)+
    geom_text(data=arr.dat,aes(x=center+11.5*cos(angle), y=center+11*sin(angle)-.8,label=val),colour="black",size=4)+
    annotation_custom(g,xmin=-2,ymin=-2,xmax=2,ymax=2)+
    
    geom_text(data=arr.dat,aes(x=center,y=center+.3,label=pc),colour="black",size=4,fontface="bold",family="Times")+
    geom_text(data=arr.dat,aes(x=center,y=center-.3),label=var.explained,colour="black",size=4,family="Times")+
   # geom_text(data=arr.dat,aes(x=center+3*cos(angle),y=center+3*sin(angle),hjust=0,vjust=0,angle=(txtangle*180/pi),label=val),colour="black",size=4)
    theme(line=element_blank(),axis.text.x=element_blank(),axis.text.y=element_blank())
  return(plot.grid)
  
}




