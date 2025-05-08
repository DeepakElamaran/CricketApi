import { LightningElement, wire,track } from 'lwc';
import handler from '@salesforce/apex/CricketApiHandler.handler';
export default class CricketApi extends LightningElement {
    matchOptions=[];
series=[];
error;
selectedMatch;
@track filteredMatches=[];
 @wire (handler)
 hand(response){
    console.log(response.data);
    if(response.data){
        this.series=response.data;
        const uniqueSeries = [...new Set(response.data.map(item => item.series))];
            this.matchOptions=uniqueSeries.map(val=>{return({
                label:val,
                value:val
     } )});
this.filteredMatches = response.data;
            
    }
    else if (response.error) {
        this.error = response.error;
        console.error('Error from Apex:', this.error);
    }
 }

 handleChange(event){
    this.selectedMatch=event.target.value;
    this.filteredMatches=this.series.filter(item=>{
        return item.series===this.selectedMatch
    }).sort((a, b) => new Date(a.dateTimeGMT) - new Date(b.dateTimeGMT));
 }
}          