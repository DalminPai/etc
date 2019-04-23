#include <TStyle.h>
#include <TChain.h>
#include <TFile.h>
#include <TH1D.h>
#include <TGraphAsymmErrors.h>
#include <TMultiGraph.h>
#include <TLegend.h>
#include <TCanvas.h>
#include <TROOT.h>
#include <THStack.h>
#include <TMath.h>
#include <TText.h>
#include <TPad.h>
#include <TPaveText.h>
#include <TLorentzVector.h>
#include <TStopwatch.h>
#include <TColor.h>
#include <TLatex.h>
#include <TEfficiency.h>
#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <vector>
#include "interface/MyCanvas.C"
#include "interface/variables.C"

using namespace std;

const double lumi = 35867.0;

///////////////////////////////////////////
// -- Channel : select "MuMu" or "EE" -- //
///////////////////////////////////////////
//--------------------------------------------------------------------------
//    For cross check with SMP-17-010
//--------------------------------------------------------------------------
// -- 2018.11.22: Copied from "dyplot_SMP_V_20181012.cc"
// -- 2019.02.14: Copied from "dyplot_for_SMP_17_010_v0131.cc"
// -- 2019.04.23: Copied from "dyplot_for_SMP_17_010_v0214.cc"
//
void dyplot_v0423(Double_t type = 6, TString channel = "EE")
{
	// -- Choose variable -- //
	TString VAR, var;
	VAR = variables(type);
	var = VAR;
	//var = "Zpeak_" + VAR;

	////////////////////////////	
	// -- Set MC histogram -- //
	////////////////////////////	
	TString inputname;
	if( channel == "MuMu" )
		inputname = "../ROOT/20190423/ROOTFile_20190208_MuMu_for_validation_on_MC.root";
	else if( channel == "EE" )
		inputname = "../ROOT/20190423/ROOTFile_20190212_EE_for_validation_on_MC.root";

	TFile f_input(inputname, "read");
	TH1D *h_DY_M10to50_v1 = (TH1D*)f_input.Get("h_"+var+"_DY"+channel+"_M10to50_v1");
	TH1D *h_DY_M10to50_v2 = (TH1D*)f_input.Get("h_"+var+"_DY"+channel+"_M10to50_v2");
	TH1D *h_DY_M10to50_ext1v1 = (TH1D*)f_input.Get("h_"+var+"_DY"+channel+"_M10to50_ext1v1");
	TH1D *h_DY_M50toInf = (TH1D*)f_input.Get("h_"+var+"_DY"+channel+"_M50toInf");

	TH1D *h_ttbar = (TH1D*)f_input.Get("h_"+var+"_ttbar");
	TH1D *h_ttbarBackup = (TH1D*)f_input.Get("h_"+var+"_ttbarBackup");

	TH1D *h_DYtautau_M10to50_v1 = (TH1D*)f_input.Get("h_"+var+"_DYTauTau_M10to50_v1");
	TH1D *h_DYtautau_M10to50_v2 = (TH1D*)f_input.Get("h_"+var+"_DYTauTau_M10to50_v2");
	TH1D *h_DYtautau_M10to50_ext1v1 = (TH1D*)f_input.Get("h_"+var+"_DYTauTau_M10to50_ext1v1");
	TH1D *h_DYtautau = (TH1D*)f_input.Get("h_"+var+"_DYTauTau");

	TH1D *h_WW = (TH1D*)f_input.Get("h_"+var+"_WW");
	TH1D *h_WZ = (TH1D*)f_input.Get("h_"+var+"_WZ");
	TH1D *h_ZZ = (TH1D*)f_input.Get("h_"+var+"_ZZ");

	TH1D *h_tW = (TH1D*)f_input.Get("h_"+var+"_tW");
	TH1D *h_antitW = (TH1D*)f_input.Get("h_"+var+"_tbarW");

	//TH1D *h_WJets = (TH1D*)f_input.Get("h_"+var+"_WJetsToLNu");
	//TH1D *h_WJets_ext = (TH1D*)f_input.Get("h_"+var+"_WJetsToLNu_ext");

	// Change Xsec
	//h_DY_M50toInf->Scale(2008.4/1952.68432327);
	//

	// Merge All DY sig
	TH1D *h_DY = (TH1D*)h_DY_M50toInf->Clone();
	h_DY->Add(h_DY_M10to50_v1);
	h_DY->Add(h_DY_M10to50_v2);
	h_DY->Add(h_DY_M10to50_ext1v1);

	// Merge ttbar
	h_ttbar->Add(h_ttbarBackup);

	// DYtautau M50 + M10to50
	h_DYtautau->Add(h_DYtautau_M10to50_v1);
	h_DYtautau->Add(h_DYtautau_M10to50_v2);
	h_DYtautau->Add(h_DYtautau_M10to50_ext1v1);

	// WW + WZ + ZZ
	TH1D* h_diboson = h_ZZ;
	h_diboson->Add(h_WZ);
	h_diboson->Add(h_WW);

	// tW + antitW
	h_tW->Add(h_antitW);

	// WJets + WJets_ext
	//h_WJets->Add(h_WJets_ext);

	// Merge processes: DY, Top, EW, QCD
	TH1D* h_Top = h_ttbar;
	h_Top->Add(h_tW);
	TH1D* h_EW = h_DYtautau;
	h_EW->Add(h_diboson);
	//TH1D* h_Fakes = h_WJets;


	//////////////////////////////
	// -- Set Data histogram -- //
	//////////////////////////////
	TString inputname2;
	if( channel == "MuMu" )
		//inputname2 = inputname;
		inputname2 = "../ROOT/20190423/ROOTFile_20190208_MuMu_for_validation_on_SingleMuon.root";
	else if( channel == "EE" )
		//inputname2 = inputname;
		inputname2 = "../ROOT/20190423/ROOTFile_20190212_EE_for_validation_on_DoubleEG.root";

	TFile f_input2(inputname2, "read");
	TH1D *h_data = (TH1D*)f_input2.Get("h_"+var+"_Data");

	///////////////////////////////
	// -- Additional settings -- //
	///////////////////////////////
	// Rebin
    if( VAR.Contains("eta") || VAR.Contains("Eta") || VAR.Contains("pT") || VAR.Contains("Pt") || VAR.Contains("rapi") )
    {
    	Int_t nRebin = 10;
		if( VAR.Contains("pT") || VAR.Contains("Pt") ) nRebin = 5;
		//else if( VAR.Contains("eta") || VAR.Contains("Eta") || VAR.Contains("rapi") ) nRebin = 20;
		//else if( VAR.Contains("rapi") ) nRebin = 20;

        h_data->Rebin(nRebin);
        h_DY->Rebin(nRebin);
        h_Top->Rebin(nRebin);
        h_EW->Rebin(nRebin);
        //h_Fakes->Rebin(nRebin);
    }

	// Check Data/MC
	TH1D *h_mc = (TH1D*)h_DY->Clone();
	h_mc->Add(h_Top);
	h_mc->Add(h_EW);
	//h_mc->Add(h_Fakes);
	Double_t nMC = h_mc->Integral();
	Double_t nData = h_data->Integral();

	////////////////////////////
	// -- General settings -- //
	////////////////////////////
	// Set Marker
	h_data->SetMarkerStyle(20);
	h_data->SetMarkerSize(0.8);

	// Set Fill Color
	h_DY->SetFillColor(kOrange-2);
	h_Top->SetFillColor(kRed+2);
	h_EW->SetFillColor(kOrange+10);
	//h_Fakes->SetFillColor(kViolet-5);

	// Set Line Color
	h_DY->SetLineColor(kOrange+3);
	h_Top->SetLineColor(kRed+4);
	h_EW->SetLineColor(kOrange+3);
	//h_Fakes->SetLineColor(kOrange+3);

	// No Stats
	h_data->SetStats(kFALSE);
	h_DY->SetStats(kFALSE);
	h_Top->SetStats(kFALSE);
	h_EW->SetStats(kFALSE);
	//h_Fakes->SetStats(kFALSE);

	// Stack histograms
	THStack* h_stack = new THStack("h_stack","");
	//h_stack->Add(h_Fakes);
	h_stack->Add(h_EW);
	h_stack->Add(h_Top);
	h_stack->Add(h_DY);

	// Output setting
	TString obj;
	if( channel == "MuMu" ) obj = "mu_channel";
	else if( channel == "EE" ) obj = "ele_channel";
	TString outputname = "../result/plot/dy/"+channel+"/20190423/for_2019KPS_"+obj;

	// Latex style
	if( channel == "MuMu" ) obj = "#mu";
	else if( channel == "EE" ) obj = "e";
	if( VAR.Contains("lead") ) obj = obj+"^{lead}";
	else if( VAR.Contains("sub") ) obj = obj+"^{sub}";

	// Legend
	TLegend* legend = new TLegend(.7,.77,.9,.92);
	legend->AddEntry(h_data,"Data");
	legend->AddEntry(h_DY,"DY"+channel,"F");
	legend->AddEntry(h_Top,"t#bar{t}+tW+#bar{t}W","F");
	legend->AddEntry(h_EW,"EW","F");
	//legend->AddEntry(h_Fakes,"Fakes(WJets)","F");
	legend->SetBorderSize(0);  
	legend->SetFillStyle(0);  

	//////////////////
	// -- Result -- //
	//////////////////
	cout << "==========================================================" << endl;
	cout << "MC input file   : " << inputname << endl;
	cout << "Data input file : " << inputname2 << endl;
	cout << "Output file	 : " << outputname << endl;
	cout << endl << "Running for [" << var << "]..." << endl;
	cout << endl << "Data/MC = " << nData/nMC << endl;
	cout << "==========================================================" << endl;


    // Make plot
    if( 0 <= fabs(type) && fabs(type) < 1 ) {
        MyCanvas *myc = new MyCanvas(outputname+"_"+var, "M("+obj+obj+") [GeV]", "Number of events");
        myc->SetLogx();
        myc->SetLogy(0);
        myc->SetXRange(15, 3000);
        myc->SetYRange(0.1, 1e8);
        //myc->SetRatioRange(0.9, 1.1);
        myc->SetRatioRange(0.7, 1.3);
        myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 1);
        myc->PrintCanvas();
    }
    else if( 1 <= fabs(type) && fabs(type) < 2 ) {
        MyCanvas *myc = new MyCanvas(outputname+"_"+var, "M("+obj+obj+") [GeV]", "Number of events");
        myc->SetLogy(0);
        myc->SetXRange(55, 125); //z-peak
        //myc->SetXRange(76, 106); //z-peak
        //myc->SetYRange(0.1, 1e8);
        myc->SetYRange(10, 1e8);
        myc->SetRatioRange(0.9, 1.1);
        //myc->SetRatioRange(0.85, 1.15);
        //myc->SetRatioRange(0.7, 1.3);
        myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 0);
        myc->PrintCanvas();
    }
    else if( 2 <= fabs(type) && fabs(type) < 3 ) { 
        MyCanvas *myc = new MyCanvas(outputname+"_"+var, "P_{T}("+obj+")", "Number of events");
        myc->SetLogy(0);
        myc->SetXRange(0, 500);
        myc->SetYRange(1, 3e8);
        myc->SetRatioRange(0.7, 1.3);
        myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 0);
        myc->PrintCanvas();
    }
    else if( 3 <= fabs(type) && fabs(type) < 4 ) {
		TString isSC = "";
		if( 3.3 <= fabs(type) && fabs(type) < 4 ) isSC = "_{sc}";
		//MyCanvas *myc = new MyCanvas(outputname+"_"+var, "#eta("+obj+")", "Number of events");
        MyCanvas *myc = new MyCanvas(outputname+"_"+var, "#eta"+isSC+"("+obj+")", "Number of events");
        myc->SetLogy(0);
        myc->SetXRange(-2.5, 2.5);
        //myc->SetYRange(0.1, 1e8);
        myc->SetYRange(100, 1e8);
        //myc->SetRatioRange(0.85, 1.15);
        //myc->SetRatioRange(0.9, 1.04);
        //myc->SetRatioRange(0.8, 1.2);
        myc->SetRatioRange(0.7, 1.3);
		//if( channel == "EE" ) myc->SetRatioRange(0.7, 1.1);
        myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 0);
        myc->PrintCanvas();
    }
    else if( 4 <= fabs(type) && fabs(type) < 5 ) {
        MyCanvas *myc = new MyCanvas(outputname+"_"+var, "#phi("+obj+")", "Number of events");
        myc->SetLogy(0);
        myc->SetXRange(-3.5, 3.5);
        myc->SetYRange(0.1, 1e8);
        //myc->SetRatioRange(0.85, 1.15);
        myc->SetRatioRange(0.8, 1.1);
        myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 0);
        myc->PrintCanvas();
    }
    else if( 5 <= fabs(type) && fabs(type) < 6 ) {
        MyCanvas *myc = new MyCanvas(outputname+"_"+var, "P_{T}("+obj+obj+")", "Number of events");
        myc->SetLogy(0);
        myc->SetXRange(0, 600);
        myc->SetYRange(0.1, 1e8);
        myc->SetRatioRange(0.7, 1.3);
        myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 0);
        myc->PrintCanvas();
    }
    else if( 6 <= fabs(type) && fabs(type) < 7 ) { 
        MyCanvas *myc = new MyCanvas(outputname+"_"+var, "Y("+obj+obj+")", "Number of events");
        myc->SetLogy(0);
        myc->SetXRange(-2.5, 2.5);
        //myc->SetYRange(0.1, 1e8);
        myc->SetYRange(10, 1e8);
        //myc->SetRatioRange(0.85, 1.15);
        myc->SetRatioRange(0.7, 1.3);
        //myc->SetRatioRange(0.9, 1.04);
		if( channel == "EE" ) myc->SetRatioRange(0.7, 1.1);

		/*h_data->GetYaxis()->SetNdivisions(505,kTRUE);
		myc->SetXRange(-2.4, 2.4);
		myc->SetYRange(0, 2.35e6);
		myc->SetRatioRange(0.7, 1.3);
		myc->SetLegendPosition(0.3,0.8,0.5,0.9);*/

//		myc->CanvasWithTHStackRatioPlot_with_unc( h_data, h_stack, h_MC, legend, "Data/MC", 0);

		myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 0);
        myc->PrintCanvas();
    }
	else {
		MyCanvas *myc = new MyCanvas(outputname+"_"+var, var, "Number of events");
		myc->SetLogy(0);
		myc->SetYRange(0.1, 1e8);
		myc->SetRatioRange(0.7, 1.3);
		myc->CanvasWithTHStackRatioPlot( h_data, h_stack, legend, "Data/MC", 0);
		myc->PrintCanvas();
	}
}

