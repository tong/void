package void.chrome;

import js.Browser.document;
import js.Browser.window;
import chrome.Bookmarks;
import chrome.History;
import chrome.Runtime;

/**
*/
class Newtab {

	static function main() {

		//document.body.textContent = "DISKTREE.NET";

		Bookmarks.getRecent( 23, function(items) {

			var bookmarks = document.getElementById( 'bookmarks' );

			for( item in items ) {

				var li = document.createLIElement();
				bookmarks.appendChild( li );

				var link = document.createAnchorElement();
				link.href = item.url;
				link.textContent = item.title;
				li.appendChild( link );
			}
		});

		History.search( { text: '', maxResults: 23 }, function(items){

			var history = document.getElementById( 'history' );

			for( item in items ) {

				var li = document.createLIElement();

				var timeElement = document.createElement( 'time' );
				var date = Date.fromTime( item.lastVisitTime );
				timeElement.textContent = formatTimeString( date );
				li.appendChild( timeElement );

				var link = document.createAnchorElement();
				link.href = item.url;
				link.textContent = item.url;
				li.appendChild( link );

				history.appendChild( li );

				//i++;
			}
		});

		/*
		window.fetch( 'https://api.github.com/users/tong' ).then( function(r){
			trace(r);
		});
		*/

	}

	static function formatTimeString( date : Date ) : String {
		return [
			formatTimeStringPart( date.getHours() ),
			formatTimeStringPart( date.getMinutes() ),
			formatTimeStringPart( date.getSeconds() ) ].join( ':' );
	}

	static inline function formatTimeStringPart( i : Int ) : String {
		return (i < 10) ? '0'+i : Std.string(i);
	}
}
