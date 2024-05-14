import { notFound } from "next/navigation";
import { type Metadata } from "next";
import edjsHTML from "editorjs-html";
import xss from "xss";
import { PageGetBySlugDocument } from "@/gql/graphql";
import { executeGraphQL } from "@/lib/graphql";

const parser = edjsHTML();

export const generateMetadata = async ({ params }: { params: { slug: string } }): Promise<Metadata> => {
	const { page } = await executeGraphQL(PageGetBySlugDocument, {
		variables: { slug: params.slug },
		revalidate: 60,
	});

	return {
		title: `${page?.seoTitle || page?.title || "Page"} - ShivaAshish Store`,
		description: page?.seoDescription || page?.seoTitle || page?.title,
	};
};

export default async function Page({ params }: { params: { slug: string } }) {
	const { page } = await executeGraphQL(PageGetBySlugDocument, {
		variables: { slug: params.slug },
		revalidate: 60,
	});

	if (!page) notFound();

	const contentHtml = page.content ? parser.parse(JSON.parse(page.content)) : null;

	return (
		<div className="mx-auto max-w-7xl p-8 pb-16">
			{contentHtml && (
				<div className="prose prose-neutral max-w-none md:prose-lg lg:prose-xl">
					{contentHtml.map((content) => (
						<div key={content} dangerouslySetInnerHTML={{ __html: xss(content) }} />
					))}
				</div>
			)}
		</div>
	);
}
