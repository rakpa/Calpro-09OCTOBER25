import { useEffect } from "react";

interface SeoProps {
  title: string;
  description: string;
  keywords?: string[];
  canonicalPath?: string;
}

function upsertMetaByName(name: string, content: string) {
  if (!content) return;
  let tag = document.querySelector(`meta[name="${name}"]`) as HTMLMetaElement | null;
  if (!tag) {
    tag = document.createElement("meta");
    tag.setAttribute("name", name);
    document.head.appendChild(tag);
  }
  tag.setAttribute("content", content);
}

function upsertMetaByProperty(property: string, content: string) {
  if (!content) return;
  let tag = document.querySelector(`meta[property="${property}"]`) as HTMLMetaElement | null;
  if (!tag) {
    tag = document.createElement("meta");
    tag.setAttribute("property", property);
    document.head.appendChild(tag);
  }
  tag.setAttribute("content", content);
}

function upsertLinkRel(rel: string, href: string) {
  if (!href) return;
  let link = document.querySelector(`link[rel="${rel}"]`) as HTMLLinkElement | null;
  if (!link) {
    link = document.createElement("link");
    link.setAttribute("rel", rel);
    document.head.appendChild(link);
  }
  link.setAttribute("href", href);
}

export default function Seo({ title, description, keywords = [], canonicalPath }: SeoProps) {
  useEffect(() => {
    // Title
    document.title = title;

    // Description & Keywords
    upsertMetaByName("description", description);
    if (keywords.length > 0) {
      upsertMetaByName("keywords", keywords.join(", "));
    }

    // Canonical URL
    const origin = window.location.origin;
    const path = canonicalPath || window.location.pathname;
    const canonicalUrl = `${origin}${path}`;
    upsertLinkRel("canonical", canonicalUrl);

    // Open Graph
    upsertMetaByProperty("og:type", "website");
    upsertMetaByProperty("og:title", title);
    upsertMetaByProperty("og:description", description);
    upsertMetaByProperty("og:url", canonicalUrl);

    // Twitter
    upsertMetaByProperty("twitter:card", "summary_large_image");
    upsertMetaByProperty("twitter:title", title);
    upsertMetaByProperty("twitter:description", description);
    upsertMetaByProperty("twitter:url", canonicalUrl);
  }, [title, description, canonicalPath, keywords.join(",")]);

  return null;
}