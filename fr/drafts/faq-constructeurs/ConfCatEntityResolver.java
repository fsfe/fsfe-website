
import java.io.IOException;
import java.net.MalformedURLException;

import org.xml.sax.EntityResolver;

import com.arbortext.catalog.Catalog;
import com.arbortext.catalog.CatalogEntityResolver;

/**
 * ConfCatEntityResolver stands for Configured CatalogEntityResolver
 * and is a wrapper around the CatalogEntityResolver class.<br />
 *
 * This wrapper's purpose is to let any XSLT processor use it
 * as an EntityResolver right out of the box, without the parser needing
 * to configure the specific CatalogEntityResolver.
 */
public class ConfCatEntityResolver extends CatalogEntityResolver {

    public ConfCatEntityResolver() {
	super();
	Catalog catalog = new Catalog();
	try {
	    catalog.loadSystemCatalogs();
	    this.setCatalog(catalog);
	} catch (MalformedURLException muex) {
	    muex.printStackTrace();
	} catch (IOException ioex) {
	    ioex.printStackTrace();
	}

    }

}
